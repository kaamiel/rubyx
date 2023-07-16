# Class is mainly a list of methods with a name.
# The methods are untyped, sis SolMethod.

# The memory layout of an object is determined by the Type (see there).
# The class carries the "current" type, ie the type an object would be if you
# created an instance of the class.
# Note that this changes over time and so many types share the same class.

# For dynamic OO it is essential that the class (the object defining the class)
# can carry methods. It does so in an instance variable methods.

# An Object carries the data for the instance variables it has.
# The Type lists the names of the instance variables
# The Class keeps a list of instance methods, these have a name and (sol) code
# Each type in turn has a list of CallableMethods that hold binary code

module Parfait
  class Class < Behaviour

    attr_reader :name

    def self.type_length
      6
    end
    def self.memory_size
      8
    end

    def initialize( name , superclass , instance_type)
      super(instance_type)
      @name = name
      @super_class = superclass
    end

    def single_class
      return @single_class if @single_class
      @single_class = SingletonClass.new( self )
    end

    def rxf_reference_name
      name
    end

    def inspect
      "Class(#{name})"
    end
    def to_s
      inspect
    end

    # return the super class, but raise exception if either the super class name
    # or the super classs is nil.
    # Use only for non Object base class
    def super_class!
      raise "No super_class for class #{@name}" if is_object?
      s = super_class
      raise "superclass not found for class #{@name}" unless s
      s
    end

    # return the super class
    # Nil means no superclass, and so nil is a valid return value
    def super_class
      @super_class
    end

    def super_class_name
      return :Object if is_object?

      @super_class.name
    end

    def is_object?
      @name == :Object
    end
    # ruby 2.1 list (just for reference, keep at bottom)
    #:allocate, :new, :superclass

    # + modules
    # :<, :<=, :>, :>=, :included_modules, :include?, :name, :ancestors, :instance_methods, :public_instance_methods,
    # :protected_instance_methods, :private_instance_methods, :constants, :const_get, :const_set, :const_defined?,
    # :const_missing, :class_variables, :remove_class_variable, :class_variable_get, :class_variable_set,
    # :class_variable_defined?, :public_constant, :private_constant, :singleton_class?, :include, :prepend,
    # :module_exec, :class_exec, :module_eval, :class_eval, :method_defined?, :public_method_defined?,
    # :private_method_defined?, :protected_method_defined?, :public_class_method, :private_class_method, :autoload,
    # :autoload?, :instance_method, :public_instance_method

  end
end
