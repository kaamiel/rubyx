module SlotMachine
  # The Compiler/Collection for the SlotMachine level is a collection of SlotMachine level
  # Method compilers These will transform to Risc MethodCompilers on the way down.
  #
  # As RubyCompiler pools source at the sol level, when several classes are compiled
  # from sol to slot, several SlotMachineCompilers get instantiated. They must be merged
  # before proceeding with translate. Thus we have a append method.
  #
  class SlotCollection
    attr_reader :method_compilers

    # Initialize with an array of risc MethodCompilers
    def initialize(compilers = [])
      @method_compilers = nil
      compilers.each{|c| add_compiler(c)}
    end

    # lazily instantiate the compiler for __init__ function and __method_missing__
    def init_compilers
      return if @init_compilers
      @init_compilers = true
      add_compiler SlotCollection.create_init_compiler
      add_compiler SlotCollection.create_mm_compiler
      self
    end

    # Return all compilers, namely the MethodCompilers instanc,
    # plus the init_compilers
    def compilers
      init_compilers
      @method_compilers
    end

    def add_compiler(compiler)
      if(@method_compilers)
        @method_compilers.add_method_compiler(compiler)
      else
        @method_compilers = compiler
      end
      self
    end

    # Append another SlotMachineCompilers method_compilers to this one.
    def append(collection)
      @method_compilers.add_method_compiler( collection.method_compilers) if collection.method_compilers
      self
    end

    def to_risc( )
      init_compilers
      riscs =[]
      @method_compilers.each_compiler do | slot_c |
        riscs << slot_c.to_risc
      end
      # to_risc all compilers
      # for each suffling constnts and fist label, then all instructions (see below)
      # then create risc collection
      Risc::RiscCollection.new(riscs)
    end

    # See Init instruction. We must have an init (ie we need it in code), so it is created in code
    def self.create_init_compiler
      compiler = compiler_for(:Object,:__init__ ,{})
      compiler._reset_for_init # no return, just for init
      compiler.add_code Init.new("missing")
      return compiler
    end

    def self.create_mm_compiler
      compiler = compiler_for(:Object,:__method_missing__ ,{})
      compiler.add_code MethodMissing.new("missing" , :r1)
      return compiler
    end

    def self.compiler_for( clazz_name , method_name , arguments , locals = {})
      frame = Parfait::Type.for_hash( locals )
      args = Parfait::Type.for_hash( arguments )
      MethodCompiler.compiler_for_class(clazz_name , method_name , args, frame )
    end

  end
end
