require_relative "helper"

module Risc
  class InterpreterDynamicCall < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = as_main("a = 5 ; return a.div4")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #5
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsZero, SlotToReg, #20
                 OperatorInstruction, IsZero, RegToSlot, LoadConstant, Branch, #25
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #30
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, LoadConstant, #40
                 SlotToReg, RegToSlot, SlotToReg, DynamicJump, LoadConstant, #45
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #50
                 RegToSlot, SlotToReg, SlotToReg, LoadData, OperatorInstruction, #55
                 RegToSlot, RegToSlot, SlotToReg, RegToSlot, Branch, #60
                 SlotToReg, Branch, SlotToReg, RegToSlot, SlotToReg, #65
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #70
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #75
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #80
                 Syscall, NilClass,] #85
       assert_equal ::Integer , get_return.class
       assert_equal 1 , get_return
    end
    def test_load_entry
      call_ins = main_ticks(3)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end
    def test_dyn
      cal = main_ticks(44)
      assert_equal DynamicJump ,  cal.class
    end
  end
end
