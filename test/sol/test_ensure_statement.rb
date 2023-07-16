require_relative 'helper'

module Sol
  class TestEnsureStatement < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main('begin; @a = 1; ensure; @a = 2; end; return')
      @ins = @compiler.slot_instructions.next
    end

    def test_compiles_body
      assert_equal SlotLoad, @ins.class, @ins
    end

    def test_compiles_ensure_setup
      assert_equal EnsureSetup, @ins.next.class, @ins.next
      assert_match /ensure_rescue_/, @ins.next(4).name
      assert_match /ensure_return_/, @ins.next(8).name
    end

    def test_compiles_ensure_body
      assert_equal SlotLoad, @ins.next(12).class, @ins.next(12)
    end

    def test_array
      check_array [SlotLoad, EnsureSetup, SlotLoad, Jump, Label, EnsureSetup, SlotLoad, Jump,
                   Label, EnsureSetup, SlotLoad, Label, SlotLoad, SlotLoad, EnsureContinuation,
                   Label, SlotLoad, ReturnJump, Label, ReturnSequence, Label], @ins
    end
  end
end
