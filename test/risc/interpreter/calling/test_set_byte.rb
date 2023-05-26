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
                 RegToSlot, SlotToReg, FunctionCall, SlotToReg, RegToSlot, #25
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #30
                 RegToByte, SlotToReg, RegToSlot, Branch, SlotToReg, #35
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #40
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #45
                 RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn, #50
                 Transfer, SlotToReg, SlotToReg, Transfer, Syscall, #55
                 NilClass,] #60
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(31)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
