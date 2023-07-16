require_relative 'helper'

module Ruby
  class TestEnsureStatementSol < MiniTest::Test
    include RubyTests

    def setup
      @lst = compile('begin; foo; ensure; bar; end').statements.first.to_sol
    end

    def test_ensure_statement
      assert_equal Sol::EnsureStatement, @lst.class
    end

    def test_body
      assert_equal Sol::SendStatement, @lst.body.class
    end

    def test_ensure_body
      assert_equal Sol::SendStatement, @lst.ensure_body.class
    end

    def test_to_s
      as_string = <<~RUBY.strip
        begin
          self.foo()
        ensure
          self.bar()
        end
      RUBY
      assert_equal as_string, @lst.to_s
    end
  end
end
