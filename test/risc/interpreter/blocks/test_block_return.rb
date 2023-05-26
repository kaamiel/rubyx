require_relative "../helper"

module Risc
  class BlockReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = yielder {return 15} ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #30
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #35
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #40
                 SlotToReg, DynamicJump, LoadConstant, RegToSlot, Branch, #45
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #50
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #55
                 SlotToReg, RegToSlot, SlotToReg, Branch, SlotToReg, #60
                 FunctionReturn, SlotToReg, RegToSlot, SlotToReg, RegToSlot, #65
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #70
                 Branch, SlotToReg, FunctionReturn, Transfer, SlotToReg, #75
                 SlotToReg, Transfer, Syscall, NilClass,] #80
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(37)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(42)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
