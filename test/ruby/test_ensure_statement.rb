require_relative 'helper'

module Ruby
  class TestEnsureStatement < MiniTest::Test
    include RubyTests

    def setup
      @lst = compile('begin; foo; ensure; bar; end').statements.first
    end

    def test_ensure_statement
      assert_equal EnsureStatement, @lst.class
    end

    def test_body
      assert_equal SendStatement, @lst.body.class
    end

    def test_ensure_body
      assert_equal SendStatement, @lst.ensure_body.class
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
