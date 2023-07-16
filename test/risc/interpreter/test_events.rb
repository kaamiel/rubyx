require_relative "helper"

module Risc
  class InterpreterEvents < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      @state_events = {}
      @instruction_events = []
      super
    end

    def state_changed( a , b)
      @state_events[:state_changed] = [a , b]
    end

    def instruction_changed(was , is )
      @instruction_events << was
    end
    def length
      30
    end
    def test_state_change
      @interpreter.register_event :state_changed , self
      ticks length
      assert @state_events[:state_changed]
      assert_equal 2 ,  @state_events[:state_changed].length
      assert_equal :running,  @state_events[:state_changed][0]
      @interpreter.unregister_event :state_changed , self
    end

    def test_instruction_events
      @interpreter.register_event :instruction_changed , self
      ticks length
      assert_equal length ,  @instruction_events.length
      @interpreter.unregister_event :instruction_changed , self
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, LoadConstant, SlotToReg, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, RegToSlot, #10
                 SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, #15
                 LoadConstant, RegToSlot, FunctionCall, LoadConstant, SlotToReg, #20
                 RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn, #25
                 Transfer, SlotToReg, SlotToReg, Transfer, Syscall, #30
                 NilClass,] #35
      assert_equal ::Integer , get_return.class
      assert_equal 5 , get_return
    end
    def test_length
      run_all
      assert_equal length , @interpreter.clock
    end
  end
end
