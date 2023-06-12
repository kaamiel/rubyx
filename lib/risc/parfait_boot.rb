module Parfait

  # The general idea is that compiling is creating an object graph. Functionally
  # one tends to think of methods, and that is complicated enough, sure.
  # But for an object system the graph includes classes and all instance variables
  #
  # And so we have a chicken and egg problem. At the end of the boot function we want
  # to have a working Space object
  # But that has instance variables (List and Dictionary) and off course a class.
  # Or more precisely in rubyx, a Type, that points to a class.
  # So we need a Type, but that has Type and Class too. hmmm
  #
  # The way out is to build empty shell objects and stuff the neccessary data into them
  #  (not use the normal initialize way)
  #  (PPS: The "real" solution is to read a rx-file graph and not do this by hand
  #    That graph can be programatically built and written (with this to boot that process :-))


  # temporary shorthand getter for the space
  # See implementation, space is now moved to inside the Object class
  # (not module anymore), but there is a lot of code (about 100, 50/50 li/test)
  # still calling this old version and since it is shorter . . .
  def self.object_space
    Object.object_space
  end

  def self.boot!(options)
    Parfait::Object.set_object_space( nil ) #case of reboot
    space = Space.new( )
    type_names.each do |name , ivars |
      ivars[:type] = :Type
      instance_type = Type.new(name , ivars , 0)
      space.add_type instance_type
      space.classes[name] = Class.new(name , nil , instance_type)
    end
    # cant set it before or new will try to take types from it
    Parfait::Object.set_object_space( space )
    fix_types
    space.init_mem(options)
  end

  # Types are hollow shells before this, so we need to set the object_class
  # and initialize the list variables (which we now can with .new)
  def self.fix_types
    fix_object_type(Parfait.object_space)
    classes = Parfait.object_space.classes
    class_type = Parfait.object_space.get_type_by_class_name(:Class)
    raise "nil type" unless class_type
    types = Parfait.object_space.types
    super_names = super_class_names
    classes.each do |name , cl|
      object_type = Parfait.object_space.get_type_by_class_name(name)
      raise "nil type" unless object_type
      cl.instance_eval{ @instance_type = object_type}
      cl.instance_eval{ @super_class = classes[super_names[name]] }
      object_type.instance_eval{ @object_class = cl }
    end
  end

  def self.fix_object_type(object)
    return unless object
    return if object.is_a?(::Integer)
    return if object.is_a?(::Symbol)
    return if object.type
    Parfait.set_type_for(object)
    object.type.names.each do |name|
      value = object.get_instance_variable(name)
      fix_object_type(value)
    end
    return unless object.is_a?(List)
    object.each {|obj| fix_object_type(obj)}
  end

  # superclasses, default Object
  def self.super_class_names
    h = {
      Object: nil,
      Data4: :DataObject,
      Data8: :DataObject,
      Data16: :DataObject,
      Data32: :DataObject,
      BinaryCode: :Data32,
      TrueClass: :Data4,
      FalseClass: :Data4,
      NilClass: :Data4,
      Integer: :Data4,
      Word: :Data8,
      List: :Data16,
      CallableMethod: :Callable,
      Block: :Callable,
      Class: :Behaviour,
      SingletonClass: :Behaviour,
      ReturnAddress: :Integer,
      StandardError: :Exception,
      RuntimeError: :StandardError,
      TypeError: :StandardError
    }
    h.default = :Object
    h
  end

  # the function really just returns a constant (just avoiding the constant)
  # unfortuantely that constant condenses every detail about the system, class names
  # and all instance variable names. Really have to find a better way
  def self.type_names
    {
      Behaviour: { instance_type: :Type, instance_methods: :List },
      BinaryCode: {next_code: :BinaryCode} ,
      Block: {binary: :BinaryCode, next_callable: :Block,
              arguments_type: :Type , self_type: :Type, frame_type: :Type,
              name: :Word , blocks: :Block } ,
      CacheEntry: {cached_type: :Type , cached_method: :CallableMethod  } ,
      Callable:   {binary: :BinaryCode,next_callable: :Callable ,
                   arguments_type: :Type , self_type: :Type, frame_type: :Type,
                   name: :Word , blocks: :Block  } ,
      CallableMethod: {binary: :BinaryCode, next_callable: :CallableMethod ,
                       arguments_type: :Type , self_type: :Type, frame_type: :Type ,
                       name: :Word , blocks: :Block} ,
      Class: { instance_methods: :List, instance_type: :Type,
               name: :Word, super_class: :Class, single_class: :SingletonClass },
      DataObject: {},
      Data4: {},
      Data8: {},
      Data16: {},
      Data32: {},
      Dictionary: {i_keys: :List , i_values: :List  } ,
      FalseClass: {},
      Factory: { for_type: :Type , next_object: :Object , reserve: :Object ,
                 attribute_name: :Word , page_size: :Integer },
      Integer: {next_integer: :Integer},
      List: {indexed_length: :Integer , next_list: :List} ,
      Message: { next_message: :Message,   receiver: :Object, frame: :Object ,
                 return_address: :Integer, return_value: :Object,
                 caller: :Message , method: :CallableMethod ,
                 exc_return_address: :Integer, exc_handler: :Message,
                 arguments_given: :Integer ,
                 arg1: :Object , arg2: :Object, arg3: :Object,
                 arg4: :Object,  arg5: :Object, arg6: :Object,
                 locals_used: :Integer,
                 local1: :Object , local2: :Object, local3: :Object, local4: :Object,
                 local5: :Object, local6: :Object ,local7: :Object, local8: :Object ,
                 local9: :Object ,local10: :Object, local11: :Object , local12: :Object,
                 local13: :Object, local14: :Object, local15: :Object},
      SingletonClass: {instance_methods: :List, instance_type: :Type, clazz: :Class },
      NilClass: {},
      Object: {},
      ReturnAddress: {next_integer: :ReturnAddress},
      Space: {classes: :Dictionary , types: :Dictionary , factories: :Dictionary,
              true_object: :TrueClass, false_object: :FalseClass , nil_object: :NilClass},
      TrueClass: {},
      Type: {names: :List , types: :List  ,
             object_class: :Class, methods: :CallableMethod ,
             is_single: :Object} ,
      SolMethod: { name: :Word , args_type: :Type , frame_type: :Type } ,
      Word: {char_length: :Integer , next_word: :Word} ,
      Exception: {},
      StandardError: {},
      RuntimeError: {},
      TypeError: {}
    }
  end

end
