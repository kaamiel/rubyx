require_relative "../helper"

module Risc
  class InterpretGetByte < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.get_byte"
      @string_input = as_main("return 'Hello'.get_internal_byte(0)")
      super
    end
    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #20
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, LoadConstant, #25
                 SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #30
                 SlotToReg, SlotToReg, SlotToReg, ByteToReg, RegToSlot, #35
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, SlotToReg, #45
                 RegToSlot, Branch, SlotToReg, SlotToReg, Branch, #50
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #55
                 Syscall, NilClass,] #60
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(34)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
