require_relative "../helper"

module Risc
  # Test the alloc sequence used by all integer operations
  class InterpreterIntAlloc < MiniTest::Test
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

    def test_load_factory
      assert_load( 18 , Parfait::Factory , :r0)
      assert_equal :next_integer , @instruction.constant.attribute_name
    end
    def test_load_nil
      assert_load( 19 , Parfait::NilClass , :r1)
    end
    def test_slot_receiver #load next_object from factory
      assert_slot_to_reg( 20 , :r0 , 2 , :r2)
    end
    def test_nil_check
      assert_operator 21 , :- ,  :r1 , :r2 , :r3
      value = @interpreter.get_register(@instruction.result)
      assert_equal ::Integer , value.class
      assert 0 != value
    end
    def test_branch
      assert_not_zero 22 , "cont_label"
    end
    def test_load_next_int
      assert_slot_to_reg( 23 , :r2 , 1 , :r1)
    end
    def test_move_next_back_to_factory
      assert_reg_to_slot( 24 , :r1 , :r0 , 2)
    end
  end
end
