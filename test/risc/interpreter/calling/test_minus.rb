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
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 1 , get_return
    end
    def test_op
      assert_operator 26  , :- , :r1 , :r3 , :r0
      assert_equal 1 , @interpreter.get_register(@instruction.result)
      assert_equal 6 , @interpreter.get_register(:r1)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(46)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r0 ,  ret.register.symbol
      assert_equal 38268 ,  @interpreter.get_register(ret.register).value
    end
  end
end
