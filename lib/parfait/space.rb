
# The Space is the root object we work off, the only singleton in the parfait world
#
# Space stores the types, classes, factories and singleton objects (true/false/nil)
#
# The Space is booted at compile time, a process outside the scope of Parfait(in parfait_boot)
# Then it is used during compilation and later serialized into the resulting binary
#
#
module Parfait

  # The Space contains all objects for a program. In functional terms it is a program, but in oo
  # it is a collection of objects, some of which are data, some classes, some functions

  # The main entry is a function called (of all things) "main".
  # This _must be supplied by the compled code (similar to c)
  # There is a start and exit block that call main, which receives an List of strings

  # While data ususally would live in a .data section, we may also "inline" it into the code
  # in an oo system all data is represented as objects

  class Space < Object

    attr_reader :classes, :types, :factories
    attr_reader :true_object, :false_object, :nil_object, :current_exception

    def self.type_length
      8
    end
    def self.memory_size
      8
    end

    # return the factory for the given type
    # or more exactly the type that has a class_name "name"
    def get_factory_for(name)
      @factories[name]
    end

    # use the factory of given name to generate next_object
    # just a shortcut basically
    def get_next_for(name)
      @factories[name].get_next_object
    end

    # yield each type in the space
    def each_type
      @types.values.each do |type|
        yield(type)
      end
    end

    # add a type, meaning the instance given must be a valid type
    def add_type( type )
      hash = type.hash
      raise "upps #{hash} #{hash.class}" unless hash.is_a?(::Integer)
      was = types[hash]
      return was if was
      types[hash] = type
    end

    # all methods form all types
    def get_all_methods
      methods = []
      each_type do | type |
        type.each_method do |meth|
          methods << meth
        end
      end
      methods
    end

    # shortcut to get at known methods that are used in the compiler
    # arguments are class and method names
    # returns method or raises (!)
    def get_method!( clazz_name , method_name )
      clazz = get_class_by_name( clazz_name )
      raise "No such class #{clazz_name}" unless clazz
      method = clazz.instance_type.get_method(method_name)
      raise "No such Method #{method_name}, in #{clazz_name}" unless method
      method
    end

    # get the current instance_typ of the class with the given name
    def get_type_by_class_name(name)
      clazz = get_class_by_name(name)
      return nil unless clazz
      clazz.instance_type
    end

    # get a class by name (symbol)
    # return nili if no such class. Use bang version if create should be implicit
    def get_class_by_name( name )
      raise "get_class_by_name #{name}.#{name.class}" unless name.is_a?(Symbol)
      c = @classes[name]
      #puts "MISS, no class #{name} #{name.class}" unless c # " #{classes}"
      #puts "CLAZZ, #{name} #{c.get_type.get_length}" if c
      c
    end

    # get or create the class by the (symbol) name
    # notice that this method of creating classes implies Object superclass
    def get_class_by_name!(name , super_class = :Object)
      c = get_class_by_name(name)
      return c if c
      create_class( name ,super_class)
    end

    # this is the way to instantiate classes (not Parfait::Class.new)
    # so we get and keep exactly one per name
    #
    # The superclass must be known when the class is created, or it raises an error.
    # The class is initiated with the type of the superclass (hence above)
    #
    # Only Sol::ClassExpression really ever creates classes and "grows" the type
    # according to the instances it finds, see there
    #
    def create_class(name, super_class_name = nil)
      raise "create_class #{name.class}" unless name.is_a? Symbol
      super_class_name ||= :Object
      raise "create_class failed for #{name}:#{super_class_name.class}" unless super_class_name.is_a? Symbol
      super_class = get_class_by_name(super_class_name)
      type = get_type_by_class_name(super_class_name)
      c = Class.new(name, super_class, type)
      c.instance_variable_set(:@instance_type, Type.for_hash(type.to_hash, c))
      @classes[name] = c
    end

    def rxf_reference_name
      "space"
    end

  end
  # ObjectSpace
  # :each_object, :garbage_collect, :define_finalizer, :undefine_finalizer, :_id2ref, :count_objects
end
