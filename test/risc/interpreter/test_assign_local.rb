require_relative "helper"

module Risc
  class InterpreterAssignLocal < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 15 ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #5
                 Branch, SlotToReg, SlotToReg, FunctionReturn, Transfer, #10
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #15
      assert_equal ::Integer , get_return.class
      assert_equal 15 , get_return
    end
    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_15
      assert_load 1 , Parfait::Integer , :r0
      assert_equal 15 , @interpreter.get_register(@interpreter.instruction.register).value
    end
    def test_branch
      assert_branch 6 , "return_label"
    end
    def test_return
      ret = main_ticks(9)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
    def test_transfer
      assert_transfer 10 , :r13 , :r14
    end
    def test_sys
      assert_syscall 14 , :exit
    end
  end
end
