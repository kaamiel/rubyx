require_relative "helper"

module Risc
  class TestInterpreterBasics < MiniTest::Test
    include ScopeHelper
    def setup
      compiler = compiler_with_main()
      @linker = compiler.to_target( :interpreter)
    end

    def test_class
      assert_equal Risc::Interpreter , Interpreter.new(@linker).class
    end
    def test_starts
      interpreter = Interpreter.new(@linker)
      @linker.position_all
      assert_equal 0 , interpreter.start_program
    end
    def test_starts_stopped
      assert_equal :stopped , Interpreter.new(@linker).state
    end
    def test_has_regs
      assert_equal 12 , Interpreter.new(@linker).registers.length
    end
    def test_has_r0
      assert_equal :r0 , Interpreter.new(@linker).registers.keys.first
    end
  end
  class TestInterpreterStarts < MiniTest::Test
    include Ticker
    def setup
      @string_input = as_main("return 5")
      super
    end
    def test_started
      assert_equal :running , @interpreter.state
    end
    def test_pos
      assert_equal 1 , @interpreter.clock
    end
  end
  class TestInterpreterTicks < MiniTest::Test
    include Ticker
    def setup
      @string_input = as_main("return 5")
      super
    end
    def test_tick1
      assert_equal 2 , @interpreter.tick
    end
    def test_clock1
      @interpreter.tick
      assert_equal 2 , @interpreter.clock
    end
    def test_pc
      @interpreter.tick
      assert_equal t = 37800 , @interpreter.pc
      @interpreter.tick
      assert_equal t + 4 , @interpreter.pc
    end
    def test_tick2
      @interpreter.tick
      assert_equal 3 , @interpreter.tick
    end
    def test_clock2
      @interpreter.tick
      @interpreter.tick
      assert_equal 3 , @interpreter.clock
    end
    def ttest_tick_14_jump
      30.times { @interpreter.tick ;puts @interpreter.instruction.class}
      assert_equal Branch , @interpreter.instruction.class
    end
    def ttest_tick_14_bin
      29.times {@interpreter.tick}
      binary_pos = binary_position
      @interpreter.tick #jump has no listener
      @interpreter.tick
      assert binary_pos.at != binary_position.at , "#{binary_pos} == #{binary_position}"
    end
    def binary_position
      pos = Position.get(@interpreter.instruction)
      list = pos.event_table[:position_changed].first
      assert_equal InstructionListener, list.class
      Position.get(list.binary)
    end
    def test_tick_15 #more than a binary code worth
      31.times {@interpreter.tick}
    end
    class TestInterpreterDies < MiniTest::Test
      include Ticker
      def setup
        @string_input = as_main("random.call")
        super
      end
      def test_dies
        # no method does syscall :dies that raises
        assert_raises {44.times {@interpreter.tick}}
      end
    end
  end
end
