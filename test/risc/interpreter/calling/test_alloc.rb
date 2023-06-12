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

    def test_load_factory
      assert_load( 24 , Parfait::Factory , :r0)
      assert_equal :next_integer , @instruction.constant.attribute_name
    end
    def test_load_nil
      assert_load( 25 , Parfait::NilClass , :r1)
    end
    def test_slot_receiver #load next_object from factory
      assert_slot_to_reg( 26 , :r0 , 2 , :r2)
    end
    def test_nil_check
      assert_operator 27 , :- ,  :r1 , :r2 , :r3
      value = @interpreter.get_register(@instruction.result)
      assert_equal ::Integer , value.class
      assert 0 != value
    end
    def test_branch
      assert_not_zero 28 , "cont_label"
    end
    def test_load_next_int
      assert_slot_to_reg( 29 , :r2 , 1 , :r1)
    end
    def test_move_next_back_to_factory
      assert_reg_to_slot( 30 , :r1 , :r0 , 2)
    end
  end
end
