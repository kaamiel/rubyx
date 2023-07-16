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
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #20
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg, #25
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, RegToSlot, #30
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #35
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #40
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, DynamicJump, LoadConstant, SlotToReg, #50
                 RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn, #55
                 SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, #60
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, SlotToReg, #65
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #70
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #75
                 Syscall, NilClass,] #80
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(43)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(48)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
