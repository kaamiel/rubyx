require_relative 'helper'

module Ruby
  class TestRescueStatement < MiniTest::Test
    include RubyTests

    def setup
      @lst = compile('begin; foo; rescue Error1, Error2; bar; else; baz; end').statements.first
    end

    def test_rescue_statement
      assert_equal RescueStatement, @lst.class
    end

    def test_body
      assert_equal SendStatement, @lst.body.class
    end

    def test_rescue_bodies
      assert_equal [RescueBodyStatement], @lst.rescue_bodies.map(&:class)
    end

    def test_else_body
      assert_equal SendStatement, @lst.else_body.class
    end

    def test_to_s
      as_string = <<~RUBY.strip
        begin
          self.foo()
        rescue Error1, Error2
          self.bar()
        else
          self.baz()
        end
      RUBY
      assert_equal as_string, @lst.to_s
    end
  end
end
