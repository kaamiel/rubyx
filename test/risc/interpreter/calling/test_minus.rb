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
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 SlotToReg, FunctionCall, LoadConstant, LoadConstant, SlotToReg, #20
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #25
                 SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, RegToSlot, #30
                 RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg, #35
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #40
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #45
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #55
       assert_equal 1 , get_return
    end
    def test_op
      assert_operator 29  , :- , :r1 , :r3 , :r0
      assert_equal 1 , @interpreter.get_register(@instruction.result)
      assert_equal 6 , @interpreter.get_register(:r1)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(49)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r0 ,  ret.register.symbol
      assert_equal 72204 ,  @interpreter.get_register(ret.register).value
    end
  end
end
