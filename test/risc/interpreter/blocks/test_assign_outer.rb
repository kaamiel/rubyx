require_relative "../helper"

module Risc
  class BlockAssignOuter < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = 15 ;yielder {a = 10 ; return 15} ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #15
                 FunctionCall, LoadConstant, SlotToReg, OperatorInstruction, IsZero, #20
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #25
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #30
                 SlotToReg, DynamicJump, LoadConstant, SlotToReg, SlotToReg, #35
                 RegToSlot, LoadConstant, RegToSlot, Branch, SlotToReg, #40
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #45
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #50
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #55
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #60
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #65
                 SlotToReg, Transfer, Syscall, NilClass,] #70
      assert_equal 10 , get_return
    end
    def base ; 32 ; end

    def test_block_jump
      load_ins = main_ticks(base)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
    end
    def test_block_load
      assert_load base+1 , Parfait::Integer , :r0
      assert_equal 10 , @interpreter.get_register(risc(base+1).register).value
    end
    def test_block_slot1
      assert_slot_to_reg base+2 ,:r13 , 6 , :r1
    end
    def test_block_slot2
      assert_slot_to_reg base+3 ,:r1 , 6 , :r2
    end
    def test_block_reg
      assert_reg_to_slot base+4 ,:r0 , :r2 , 18
    end
    def test_ret_load
      assert_load base+5 , Parfait::Integer , :r0
      assert_equal 15 , @interpreter.get_register(risc(base+5).register).value
    end
  end
end
