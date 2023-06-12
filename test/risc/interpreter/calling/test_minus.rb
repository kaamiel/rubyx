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
       assert_equal 1 , get_return
    end
    def test_op
      assert_operator 35  , :- , :r1 , :r3 , :r0
      assert_equal 1 , @interpreter.get_register(@instruction.result)
      assert_equal 6 , @interpreter.get_register(:r1)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(56)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r0 ,  ret.register.symbol
      assert_equal 39372 ,  @interpreter.get_register(ret.register).value
    end
  end
end
