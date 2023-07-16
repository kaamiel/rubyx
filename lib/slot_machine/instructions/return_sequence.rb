module SlotMachine

  # The ReturnSequence models the return from a method.
  #
  # This involves the jump to the return address stored in the message, and
  # the reinstantiation of the previous message.
  #
  # The (slot) machine only ever "knows" one message, the current message.
  # Messages are a double linked list, calling involves going forward,
  # returning means going back.
  #
  # The return value of the current message is transferred into the return value of the
  # callers return value during the swap of messages, and just before the jump.
  #
  # The callers perspective of a call is the magical apperance of a return_value
  # in it's message at the instruction after the call.
  #
  # The instruction is not parameterized as it translates to a constant
  # set of lower level instructions.
  #
  class ReturnSequence < Instruction
    def to_risc(compiler)
      compiler.build(to_s) do
        return_address = message[:return_address].to_reg
        message << message[:caller]
        add_code Risc.function_return("return #{compiler.callable.name}", return_address)
      end
    end

    def to_s
      "ReturnSequence"
    end
  end

end
