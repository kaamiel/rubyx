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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #20
                 LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, #25
                 SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #30
                 Transfer, Transfer, Transfer, Syscall, Transfer, #35
                 Transfer, SlotToReg, Branch, RegToSlot, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #50
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #55
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, Branch, #60
                 SlotToReg, Transfer, Syscall, NilClass,] #65
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal Integer , get_return.class
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(20)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_pre_sys
      done = main_ticks(33)
      assert_equal Parfait::Word , @interpreter.get_register(@interpreter.std_reg(:syscall_2)).class
      assert_equal "Hello again" , @interpreter.get_register(@interpreter.std_reg(:syscall_2)).to_string
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_3))
    end

    def test_sys
      done = main_ticks(34)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_1))
    end

    def test_move_sys_return
      assert_transfer(35, :r0 ,:r1)
      assert_equal 11 , @interpreter.get_register(@interpreter.std_reg(:syscall_1))
    end
    def test_restore_message
      assert_transfer(36, :r14 ,:r13)
      assert_equal Parfait::Message , @interpreter.get_register(:r13).class
    end
    def test_return
      done = main_ticks(57)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
