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
                 SlotToReg, FunctionCall, LoadConstant, LoadConstant, SlotToReg, #20
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #25
                 SlotToReg, Transfer, Transfer, LoadData, OperatorInstruction, #30
                 LoadData, OperatorInstruction, OperatorInstruction, LoadData, Branch, #35
                 Transfer, OperatorInstruction, OperatorInstruction, LoadData, Transfer, #40
                 OperatorInstruction, OperatorInstruction, LoadData, Transfer, OperatorInstruction, #45
                 OperatorInstruction, LoadData, OperatorInstruction, LoadData, Transfer, #50
                 OperatorInstruction, OperatorInstruction, Transfer, LoadData, OperatorInstruction, #55
                 LoadData, OperatorInstruction, OperatorInstruction, RegToSlot, RegToSlot, #60
                 SlotToReg, RegToSlot, Branch, SlotToReg, Branch, #65
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #70
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #75
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #80
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #85
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 10
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = risc(79)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
  end
end
