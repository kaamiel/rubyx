require_relative "helper"

module Ruby
  # other Return tests (standalone?) only test the statement
  # But to get the implicit return, we test the method, as it inserts
  # the implicit return
  class TestMethodStatementRet < MiniTest::Test
    include RubyTests
    def test_single_const
      @lst = compile( "def tryout(arg1, arg2) ; true ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.class
    end
    def test_single_instance
      @lst = compile( "def tryout(arg1, arg2) ; @a ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.class
    end
    def test_single_call
      @lst = compile( "def tryout(arg1, arg2) ; is_true() ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.class
    end

    def test_multi_const
      @lst = compile( "def tryout(arg1, arg2) ; @a = some_call(); true ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.last.class
    end
    def test_multi_instance
      @lst = compile( "def tryout(arg1, arg2) ; @a = some_call(); @a ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.last.class
    end
    def test_multi_call
      @lst = compile( "def tryout(arg1, arg2) ; is_true() ; some_call() ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.last.class
    end

    def test_return
      @lst = compile( "def tryout(arg1, arg2) ; return 1 ; end " ).to_sol
      assert_equal Sol::ReturnStatement , @lst.body.class
      assert_equal Sol::IntegerConstant , @lst.body.return_value.class
    end
    def test_local_assign
      @lst = compile( "def tryout(arg1, arg2) ; a = 1 ; end " ).to_sol
      assert_equal Sol::Statements , @lst.body.class
      assert_equal Sol::ReturnStatement , @lst.body.last.class
      assert_equal Sol::LocalVariable , @lst.body.last.return_value.class
    end
    def test_local_assign
      @lst = compile( "def tryout(arg1, arg2) ; @a = 1 ; end " ).to_sol
      assert_equal Sol::Statements , @lst.body.class
      assert_equal Sol::ReturnStatement , @lst.body.last.class
      assert_equal Sol::InstanceVariable , @lst.body.last.return_value.class
    end
    def test_rescue_nil
      @lst = compile('def tryout(arg1, arg2); begin; rescue; end; end').to_sol
      assert_equal Sol::ReturnStatement, @lst.body.class
      assert_equal Sol::NilConstant, @lst.body.return_value.class
    end
    def test_rescue
      @lst = compile('def tryout(arg1, arg2); foo; begin; bar; rescue; baz; end; end').to_sol
      assert_equal Sol::Statements, @lst.body.class
      assert_equal Sol::RescueStatement, @lst.body.last.class
      assert_equal Sol::ReturnStatement, @lst.body.last.body.class
      assert_equal [Sol::ReturnStatement], @lst.body.last.rescue_bodies.map(&:body).map(&:class)
    end
    def test_rescue_else
      @lst = compile('def tryout(arg1, arg2); begin; foo; rescue; bar; else; baz; end; end').to_sol
      assert_equal Sol::RescueStatement, @lst.body.class
      assert_equal Sol::ReturnStatement, @lst.body.else_body.class
      assert_equal [Sol::ReturnStatement], @lst.body.rescue_bodies.map(&:body).map(&:class)
    end
    def test_ensure
      @lst = compile('def tryout(arg1, arg2); begin; foo; ensure; bar; end; end').to_sol
      assert_equal Sol::EnsureStatement, @lst.body.class
      assert_equal Sol::ReturnStatement, @lst.body.body.class
      assert_equal Sol::SendStatement, @lst.body.ensure_body.class
    end
    def test_ensure_no_body
      @lst = compile('def tryout(arg1, arg2); begin; ensure; foo; end; end').to_sol
      assert_equal Sol::EnsureStatement, @lst.body.class
      assert_equal Sol::ReturnStatement, @lst.body.body.class
      assert_equal Sol::NilConstant, @lst.body.body.return_value.class
    end
  end
end
