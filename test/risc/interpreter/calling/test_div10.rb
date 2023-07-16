require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div10"
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, Transfer, #30
                 Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction, #35
                 OperatorInstruction, LoadData, Branch, Transfer, OperatorInstruction, #40
                 OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, #45
                 LoadData, Transfer, OperatorInstruction, OperatorInstruction, LoadData, #50
                 OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, #55
                 Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction, #60
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #65
                 RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn, #70
                 SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, #75
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #80
                 Transfer, Syscall, NilClass,] #85
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 10
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = risc(77)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
  end
end
