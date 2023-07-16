require_relative "../helper"

module Risc
  class InterpretSetByte < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.set_byte"
      @string_input = as_main("return 'Hello'.set_internal_byte(0,75)")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #20
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #25
                 FunctionCall, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #30
                 SlotToReg, SlotToReg, SlotToReg, RegToByte, SlotToReg, #35
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #40
                 FunctionReturn, SlotToReg, SlotToReg, RegToSlot, Branch, #45
                 Branch, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #55
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(34)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
