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
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #30
                 SlotToReg, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #45
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #50
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #55
                 Transfer, Syscall, NilClass,] #60
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 18 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      assert_operator 32 , :*,  :r1 , :r3 , :r0
      assert_equal 2147483648 , @interpreter.get_register(:r3)
      assert_equal 2147483648 , @interpreter.get_register(:r1)
    end
    def test_overflow
      main_ticks( 32 )
      assert @interpreter.flags[:overflow]
    end
  end
end
