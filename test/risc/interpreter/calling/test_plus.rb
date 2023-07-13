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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 SlotToReg, FunctionCall, LoadConstant, LoadConstant, SlotToReg, #20
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #25
                 SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, RegToSlot, #30
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch, #35
                 Branch, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end
    def test_op
      assert_operator 29, :+ ,  :r1 ,  :r3 , :r0
      assert_equal 10 , @interpreter.get_register(@instruction.result.symbol)
    end
    def test_move_res_to_int
      assert_reg_to_slot( 30 , :r0 , :r2 , 2)
    end
    def test_move_int_to_reg
      assert_reg_to_slot( 31 , :r2 , :r13 , 5)
    end
  end
end
