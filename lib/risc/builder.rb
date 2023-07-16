module Risc

  # A Builder is used to generate code, either by using it's api, or dsl
  #
  # The code is added to the method_compiler.
  #
  # Basically this allows to express many Risc instructions with extremely readable code.
  # example:
  #  space << Parfait.object_space # load constant
  #  message[:receiver] << space  #make current message's (r0) receiver the space
  # See http://ruby-x.org/rubyx/builder.html for details
  #
  class Builder

    attr_reader :built , :compiler

    # pass a compiler, to which instruction are added (usually)
    # call build with a block to build
    def initialize(compiler, for_source)
      raise "no compiler" unless compiler
      raise "no source" unless for_source
      @compiler = compiler
      @source = for_source
      @source_used = false
    end

    # especially for the macros (where register allocation is often manual)
    # register need to be created. And since the code is "ported" we create
    # them with the old names, which used the infer_type to infer the type
    #
    # Return the RegisterValue with given name and inferred type, compiler set
    def register( name )
      RegisterValue.new(name , infer_type(name) ).set_compiler(compiler)
    end

    # create an add a RegisterTransfer instruction with to and from
    def transfer(to , from)
      add_code Risc.transfer(@source, to , from)
    end

    # Infer the type from a symbol. In the simplest case the symbol is the class name.
    # But in building, sometimes variations are needed, so next_message or caller work
    # too (and both return "Message")
    # A general "_reg"/"_obj"/"_const" or "_tmp" at the end of the name will be removed
    # An error is raised if the symbol/object can not be inferred
    def infer_type( name )
      as_string = name.to_s
      parts = as_string.split("_")
      if( ["reg" , "obj" , "tmp" , "self" , "const", "1" , "2"].include?( parts.last ) )
        parts.pop
        as_string = parts.join("_")
      end
      as_string = "word" if as_string == "name"
      as_string = "message" if as_string == "next_message"
      as_string = "message" if as_string == "caller"
      sym = as_string.camelise.to_sym
      clazz = Parfait.object_space.get_class_by_name(sym)
      raise "Not implemented/found object #{name}:#{sym}" unless clazz
      return clazz.instance_type
    end

    def if_zero( label )
      @source_used = true
      add_code Risc::IsZero.new(@source , label)
    end
    def if_not_zero( label )
      @source_used = true
      add_code Risc::IsNotZero.new(@source , label)
    end
    def if_minus( label )
      @source_used = true
      add_code Risc::IsMinus.new(@source , label)
    end
    def branch( label )
      @source_used = true
      add_code Risc::Branch.new(@source, label)
    end

    # Build code using dsl (see __init__ or MessageSetup for examples).
    # Names (that ruby would resolve to a variable/method) are converted
    # to registers. << means assignment and [] is supported both on
    # L and R values (but only one at a time). R values may also be constants.
    #
    # Basically this allows to create LoadConstant, RegToSlot, SlotToReg and
    # Transfer instructions with extremely readable code.
    # example:
    #  space << Parfait.object_space # load constant
    #  message[:receiver] << space  #make current message's (r0) receiver the space
    #
    # build result is added to compiler directly
    #
    def build(&block)
      instance_eval(&block)
    end

    # make the message register available for the dsl
    def message
      Risc.message_named_reg.set_compiler(@compiler)
    end

    # add code straight to the compiler
    def add_code(ins)
      @compiler.add_code(ins)
      return ins
    end

    def load_object(object , into = nil)
      @compiler.load_object(object , into)
    end

    # for some methods that return an integer it is beneficial to pre allocate the
    # integer and store it in the return value. That is what this function does.
    #
    # Those (builtin) methods, mostly syscall wrappers then go on to do this and that
    # clobbering registers and so the allocate and even move would be difficult.
    # We sidestep all that by pre-allocating.
    #
    # Note: this was pre register-allocate. clobbering is history, maybe revisit?
    def prepare_int_return
      message[:return_value] << allocate_int
    end

    # allocate int fetches a new int, for sure. It is a builder method, rather than
    # an inbuilt one, to avoid call overhead for 99.9%
    # The factories allocate in 1k, so only when that runs out do we really need a call.
    # Note:
    #   Unfortunately (or so me thinks), this creates code bloat, as the calling is
    #   included in 100%, but only needed in 0.1. Risc-level Blocks or Macros may be needed.
    #   as the calling in (the same) 40-50 instructions for every basic int op.
    #
    # The method
    # - grabs a Integer instance from the Integer factory
    # - checks for nil and calls (get_more) for more if needed
    # - returns the RiscValue (Register) where the object is found
    #
    # The implicit condition is that the method is called at the entry of a method.
    # It uses a fair few registers and resets all at the end. The returned object
    # will always be in r1, because the method resets, and all others will be clobbered.
    #
    # Return RegisterValue(:r1) that will be named integer_tmp
    def allocate_int
      cont_label = Risc.label("continue int allocate" , "cont_label")
      factory = load_object Parfait.object_space.get_factory_for(:Integer)
      null = load_object Parfait.object_space.nil_object
      int = nil
      build do
        int = factory[:next_object].to_reg.known_type(:Integer)
        null.op :- , int
        if_not_zero cont_label
          factory[:next_object] << factory[:reserve]
          call_get_more
        add_code cont_label
        factory[:next_object] << int[:next_integer]
      end
      int
    end

    # Call_get_more calls the method get_more on the factory (see there).
    # From the callers perspective the method ensures there is a next_object.
    #
    # Calling is three step process
    # - setting up the next message
    # - moving receiver (factory) and arguments (none)
    # - issuing the call
    # These steps shadow the SlotMachineInstructions MessageSetup, ArgumentTransfer and SimpleCall
    def call_get_more
      int_factory = Parfait.object_space.get_factory_for(:Integer)
      factory = load_object int_factory
      calling = int_factory.get_type.get_method( :get_more )
      calling = Parfait.object_space.get_method!(:Space,:main) #until we actually parse Factory
      raise "no main defined" unless calling
      SlotMachine::MessageSetup.new( calling ).build_with( self )
      message[:receiver] << factory
      SlotMachine::SimpleCall.new(calling).to_risc(compiler)
    end

    def allocate_exception
      factory = load_object Parfait.object_space.get_factory_for(:Exception)
      exception = nil
      build do
        exception = factory[:next_object].to_reg.known_type(:Exception)
        factory[:next_object] << exception[:next_exception]
      end

      exception
    end
  end
end
