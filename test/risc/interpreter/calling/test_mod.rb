require_relative "../helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = as_main "return 9.div4"
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 SlotToReg, FunctionCall, LoadConstant, LoadConstant, SlotToReg, #20
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #25
                 SlotToReg, LoadData, OperatorInstruction, RegToSlot, RegToSlot, #30
                 SlotToReg, RegToSlot, Branch, SlotToReg, Branch, #35
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #40
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #45
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #55
       assert_equal 2 , get_return
    end

    def test_op
      assert_operator 28 , :>>,  :r1 , :r0 , :r3
      assert_equal 2 , @interpreter.get_register(:r0)
      assert_equal 9 , @interpreter.get_register(:r1)
    end
  end
end
