module Sol

  # A Yield is a lot like a Send, which is why they share the base class CallStatement
  # That means it has a receiver (self), arguments and an (implicitly assigned) name
  #
  # On the ruby side, normalisation works pretty much the same too.
  #
  # On the way down to SlotMachine, small differences become abvious, as the block that is
  # yielded to is an argument. Whereas in a send it is either statically known
  # or resolved and cached. Here it is dynamic, but sort of known dynamic.
  # All we do before calling it is check that it is the right type.
  class YieldStatement < CallStatement

    # A Yield breaks down to 2 steps:
    # - Setting up the next message, with receiver, arguments, and (importantly) return address
    # - a SimpleCall,
    def to_slot( compiler )
      @parfait_block = @block.to_slot(compiler) if @block
      @receiver = SelfExpression.new(compiler.receiver_type) if @receiver.is_a?(SelfExpression)
      yield_call(compiler)
    end

    # this breaks into two parts:
    # - check the calling method and break to a (not implemented) dynamic version
    # - call the block, that is the last argument of the method
    def yield_call(compiler)
      method_check(compiler) << yield_arg_block(compiler)
    end

    # check that the calling method is the method that the block was created in.
    # In that case variable resolution is reasy and we can prceed to yield
    # Note: the else case is not implemented (ie passing lambdas around)
    #      this needs run-time variable resolution, which is just not done.
    #      we brace ourselves with the check, and exit (later raise) if . . .
    def method_check(compiler)
      ok_label = SlotMachine::Label.new(self,"method_ok_#{self.object_id}")
      compile_method = SlotMachine::Slotted.for( compiler.get_method )
      runtime_method = SlotMachine::Slotted.for( :message , [ :method] )
      check = SlotMachine::NotSameCheck.new(compile_method , runtime_method, ok_label)
      # TODO? Maybe create slot instructions for this
      #builder = compiler.builder("yield")
      #Risc::Macro.exit_sequence(builder)
      #check << builder.built
      check << ok_label
    end

    # to call the block (that we know now to be the last arg),
    # we do a message setup, arg transfer and the a arg_yield (which is similar to dynamic_call)
    def yield_arg_block(compiler)
      arg_index = compiler.get_method.arguments_type.get_length - 1
      setup = SlotMachine::MessageSetup.new(arg_index, compiler.get_exception_return_label)
      slot_receive = @receiver.to_slotted(compiler)
      args = @arguments.collect { |arg|  arg.to_slotted(compiler)}
      setup << SlotMachine::ArgumentTransfer.new( self , slot_receive , args )
      setup << SlotMachine::BlockYield.new( self , arg_index )
    end

  end
end
