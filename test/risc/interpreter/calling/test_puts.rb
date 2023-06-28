require_relative "../helper"

module Risc
  class TestPuts < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.put"
      @string_input = as_main(" return 'Hello again'.putstring ")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, RegToSlot, SlotToReg, SlotToReg, Transfer, #25
                 Transfer, Transfer, Syscall, Transfer, Transfer, #30
                 SlotToReg, Branch, RegToSlot, SlotToReg, RegToSlot, #35
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #40
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #45
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #50
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #55
                 Syscall, NilClass,] #60
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal Integer , get_return.class
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(14)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_pre_sys
      done = main_ticks(27)
      assert_equal Parfait::Word , @interpreter.get_register(@interpreter.std_reg(:syscall_2)).class
      assert_equal "Hello again" , @interpreter.get_register(@interpreter.std_reg(:syscall_2)).to_string
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_3))
    end

    def test_sys
      done = main_ticks(28)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_1))
    end

    def test_move_sys_return
      assert_transfer(29, :r0 ,:r1)
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_1))
    end
    def test_restore_message
      assert_transfer(30, :r14 ,:r13)
      assert_equal Parfait::Message , @interpreter.get_register(:r13).class
    end
    def test_return
      done = main_ticks(51)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
