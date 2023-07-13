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
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #40
                 LoadConstant, SlotToReg, LoadConstant, SlotToReg, RegToSlot, #45
                 SlotToReg, DynamicJump, LoadConstant, LoadConstant, SlotToReg, #50
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #55
                 SlotToReg, LoadData, OperatorInstruction, RegToSlot, RegToSlot, #60
                 SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, #65
                 SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot, #70
                 Branch, SlotToReg, SlotToReg, FunctionReturn, Transfer, #75
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #80
       assert_equal ::Integer , get_return.class
       assert_equal 1 , get_return
    end
    def test_load_entry
      call_ins = main_ticks(3)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end
    def test_dyn
      cal = main_ticks(47)
      assert_equal DynamicJump ,  cal.class
    end
  end
end
