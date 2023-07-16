require_relative 'helper'

module Sol
  class TestRescueBodyStatement < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main('begin; @a = 1; rescue StandardError; @a = 2; end; return')
      @ins = @compiler.slot_instructions.next
    end

    def test_compiles_body
      assert_equal SlotLoad, @ins.class, @ins
      assert_equal Jump, @ins.next.class, @ins.next
    end

    def test_compiles_rescue_body
      rescue_1 = @ins.next(2)

      assert_equal Label, rescue_1.class
      assert_match /handle_exception_[[:alnum:]]+_rescue_1/, rescue_1.name
      assert_equal MatchExceptionClass, rescue_1.next.class
    end

    def test_compiles_exception_class_not_matched
      exception_class_not_matched = @ins.next(7)

      assert_equal Label, exception_class_not_matched.class
      assert_match /handle_exception_[[:alnum:]]+_rescue_2/, exception_class_not_matched.name
      assert_equal Raise, exception_class_not_matched.next.class
    end

    def test_array
      check_array [SlotLoad, Jump, Label, MatchExceptionClass, SlotLoad, SlotLoad, Jump,
                   Label, Raise , Label, SlotLoad, ReturnJump, Label, ReturnSequence, Label], @ins
    end
  end
end
