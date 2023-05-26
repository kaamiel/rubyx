require_relative "../helper"

module Risc
  class InterpreterMinusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.minus"
      @string_input = as_main("return 6 - 5")
      super
    end

    def test_minus
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
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
       assert_equal 1 , get_return
    end
    def test_op
      assert_operator 32  , :- , :r1 , :r3 , :r0
      assert_equal 1 , @interpreter.get_register(@instruction.result)
      assert_equal 6 , @interpreter.get_register(:r1)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(52)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r0 ,  ret.register.symbol
      assert_equal 38396 ,  @interpreter.get_register(ret.register).value
    end
  end
end
