require_relative 'helper'

module Ruby
  class TestRescueBodyStatementSol < MiniTest::Test
    include RubyTests

    def setup
      @lst = compile('begin; rescue Error1, Error2; foo; end').statements.first.rescue_bodies.first.to_sol
    end

    def test_rescue_body_statement
      assert_equal Sol::RescueBodyStatement, @lst.class
    end

    def test_exception_classes
      assert_equal [Sol::ModuleName, Sol::ModuleName], @lst.exception_classes.map(&:class)
    end

    def test_assignment
      assert_nil @lst.assignment
    end

    def test_body
      assert_equal Sol::SendStatement, @lst.body.class
    end
  end
end
