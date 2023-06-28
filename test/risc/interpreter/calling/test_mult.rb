require_relative "../helper"

module Risc
  class InterpreterMultTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.mul"
      @string_input = as_main "return #{2**31} * #{2**31}"
      super
    end

    def test_mult
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 SlotToReg, FunctionCall, LoadConstant, LoadConstant, SlotToReg, #20
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #25
                 SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, RegToSlot, #30
                 RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg, #35
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #40
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #45
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #55
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 15 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      assert_operator 29 , :*,  :r1 , :r3 , :r0
      assert_equal 2147483648 , @interpreter.get_register(:r3)
      assert_equal 2147483648 , @interpreter.get_register(:r1)
    end
    def test_overflow
      main_ticks( 29 )
      assert @interpreter.flags[:overflow]
    end
  end
end
