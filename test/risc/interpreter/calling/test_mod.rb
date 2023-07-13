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
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, LoadData, #30
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn, #40
                 SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, #45
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #50
                 Transfer, Syscall, NilClass,] #55
       assert_equal 2 , get_return
    end

    def test_op
      assert_operator 31 , :>>,  :r1 , :r0 , :r3
      assert_equal 2 , @interpreter.get_register(:r0)
      assert_equal 9 , @interpreter.get_register(:r1)
    end
  end
end
