require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
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
       assert_equal 10 , get_return
    end
    def test_op
      assert_operator 35, :+ ,  :r1 ,  :r3 , :r0
      assert_equal 10 , @interpreter.get_register(@instruction.result.symbol)
    end
    def test_move_res_to_int
      assert_reg_to_slot( 36 , :r0 , :r2 , 2)
    end
    def test_move_int_to_reg
      assert_reg_to_slot( 37 , :r2 , :r13 , 5)
    end
  end
end
