# From a programmers perspective an object has hash like data (with instance variables as keys)
# and functions to work on that data.
# Only the object may access it's data directly.

# From an implementation perspective it is a chunk of memory with a type as the first
# word (instance of class Type).

# Objects are arranged or layed out (in memory) according to their Type
# every object has a Type. Type objects are immutable and may be reused for a group/class
# of objects.
# The Type of an object may change, but then a new Type is created
# The Type also defines the class of the object
# The Type is **always** the first entry (index 0) in an object

module Parfait
  class Object
    attr_reader :type

    def self.type_length
      1
    end
    def self.memory_size
      4
    end
    # Make the object space globally available
    def self.object_space
      @object_space
    end

    def self.new
      factory = @object_space.get_factory(:Object)
      object = factory.get_next
      object.initialize
    end

    def type=(t)
      set_type( t )
    end

    def == other
      self.object_id == other.object_id
    end

    # This is the core of the object system.
    # The class of an object is stored in the objects memory
    #
    # In RubyX we store the class in the Type, and so the Type is the only fixed
    # data that every object carries.
    def get_class()
      l = get_type()
      #puts "Type #{l.class} in #{self.class} , #{self}"
      l.object_class()
    end

    # private
    def set_type(typ)
      raise "not type " + typ.class.to_s unless typ.is_a?(Type)
      @type = typ
    end

    # so we can keep the raise in get_type
    def has_type?
      ! @type.nil?
    end

    def get_type()
      raise "No type: " + self.class.name + " : " + self.to_s unless @type
      @type
    end

    def get_instance_variables
      @type.names
    end

    def get_instance_variable( name )
      index = instance_variable_defined(name)
      #raise "at :#{name}:" if name.to_s[0] == "@"
      return nil if index == nil
      return get_internal_word(index)
    end

    def set_instance_variable( name , value )
      index = instance_variable_defined(name)
      #puts "setting #{name} at #{index}"
      return nil if index == nil
      return set_internal_word(index , value)
    end

    def instance_variable_defined( name )
      @type.variable_index(name)
    end

    # objects only come in lengths of multiple of 8 words / 32 bytes
    # and there is a "hidden" 1 word that is used for debug/check memory corruption
    def self.padded( len )
      a = 32 * (1 + ((len + 3)/32).floor )
      #puts "#{a} for #{len}"
      return a
    end

    def self.padded_words( words )
      padded(words*4) # 4 == word length, a constant waiting for a home
    end

    def padded_length
      Object.padded_words( @type.instance_length )
    end

    # parfait versions are deliberately called different, so we "relay"
    # have to put the "" on the names for rfx to take them off again
    def instance_variables
      get_instance_variables.to_a.collect{ |n| n.to_s.to_sym }
    end

  end
end
