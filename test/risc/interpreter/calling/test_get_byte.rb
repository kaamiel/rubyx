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
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #30
                 ByteToReg, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #35
                 Branch, SlotToReg, Branch, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #45
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #50
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #55
                 Transfer, Syscall, NilClass,] #60
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(31)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
