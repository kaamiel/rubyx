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
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #30
                 SlotToReg, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #45
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #50
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #55
                 Transfer, Syscall, NilClass,] #60
       assert_equal 10 , get_return
    end
    def test_op
      assert_operator 32, :+ ,  :r1 ,  :r3 , :r0
      assert_equal 10 , @interpreter.get_register(@instruction.result.symbol)
    end
    def test_move_res_to_int
      assert_reg_to_slot( 33 , :r0 , :r2 , 2)
    end
    def test_move_int_to_reg
      assert_reg_to_slot( 34 , :r2 , :r13 , 5)
    end
  end
end
