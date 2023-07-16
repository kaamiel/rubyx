require_relative "helper"

module Risc
  class InterpreterReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, Branch, SlotToReg, #5
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #10
                 Transfer, Syscall, NilClass,] #15
      assert_equal 5 , get_return
    end

    def test_call_main
      assert_function_call 0 , :main
    end

    def test_function_return
      ret = main_ticks(7)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
  end
end
