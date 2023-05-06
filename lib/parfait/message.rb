
# A message is what is created when a message is sent. Args and stuff are packed up in to a
# Message and the Message is activated (by swapping it into the machine).

# Part of the housekeeping (see attributes) makes messages a double linked list (next_message and
# caller) , and maybe surprisingly this means that we can create all messages at compile-time
# and link them up and never have to touch that list again.
# All the args and receiver data changes, but the list of messages stays constant
#  (a pleasant stupor while we ignore closures and longer extended frames ).

module Parfait
  class Message < Object

    attr_reader  :next_message,  :receiver
    attr_reader  :return_address, :return_value
    attr_reader  :caller , :method
    attr_reader  :exc_return_address, :exc_handler
    attr_reader  :arguments_given, :arg1 , :arg2, :arg3, :arg4, :arg5, :arg6
    attr_reader  :locals_used, :local1 , :local2, :local3, :local4, :local5, :local6 ,:local7
    attr_reader  :local8 , :local9 ,:local10, :local11 , :local12, :local13, :local14

    def self.type_length
      32
    end
    def self.memory_size
      32
    end
    def self.args_start_at
      Object.object_space.get_type_by_class_name(:Message).variable_index(:arguments_given)
    end
    def self.locals_start_at
      Object.object_space.get_type_by_class_name(:Message).variable_index(:locals_used)
    end

    def initialize(  )
      super()
      @locals_used = Parfait::Integer.new(0)
      @arguments_given = Parfait::Integer.new(0)
    end
    public :initialize

    def set_receiver(rec)
      @receiver = rec
    end

    def set_caller(caller)
      @caller = caller
    end

    def get_type_for(name)
      index = @type.get_index(name)
      get_at(index)
    end

    def method_name
      return "" unless @method
      return "" unless @method == NilClass
      @method.name
    end
    def to_s
      id = @method ? @method.name : object_id.to_s(16)
      "Message:#{id}(#{@arguments_given.value})"
    end

    def _set_next_message(nekst)
      @next_message = nekst
    end
    def _set_caller(prev)
      @caller = prev
    end
  end
end
