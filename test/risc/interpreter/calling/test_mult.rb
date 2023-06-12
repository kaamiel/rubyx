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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #20
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, LoadConstant, #25
                 SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #30
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, #35
                 RegToSlot, RegToSlot, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #50
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #55
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #60
                 Syscall, NilClass,] #65
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 21 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      assert_operator 35 , :*,  :r1 , :r3 , :r0
      assert_equal 2147483648 , @interpreter.get_register(:r3)
      assert_equal 2147483648 , @interpreter.get_register(:r1)
    end
    def test_overflow
      main_ticks( 35 )
      assert @interpreter.flags[:overflow]
    end
  end
end
