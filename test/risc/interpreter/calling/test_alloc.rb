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

    def test_load_factory
      assert_load( 21 , Parfait::Factory , :r0)
      assert_equal :next_integer , @instruction.constant.attribute_name
    end
    def test_load_nil
      assert_load( 22 , Parfait::NilClass , :r1)
    end
    def test_slot_receiver #load next_object from factory
      assert_slot_to_reg( 23 , :r0 , 2 , :r2)
    end
    def test_nil_check
      assert_operator 24 , :- ,  :r1 , :r2 , :r3
      value = @interpreter.get_register(@instruction.result)
      assert_equal ::Integer , value.class
      assert 0 != value
    end
    def test_branch
      assert_not_zero 25 , "cont_label"
    end
    def test_load_next_int
      assert_slot_to_reg( 26 , :r2 , 1 , :r1)
    end
    def test_move_next_back_to_factory
      assert_reg_to_slot( 27 , :r1 , :r0 , 2)
    end
  end
end
