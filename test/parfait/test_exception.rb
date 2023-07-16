require_relative 'helper'

module Parfait
  class TestException < ParfaitTest
    def setup
      @exception = Exception.new
    end

    def test_to_s
      assert_equal 'Exception', @exception.to_s
    end
  end

  class TestStandardError < ParfaitTest
    def setup
      @exception = StandardError.new
    end

    def test_to_s
      assert_equal 'StandardError', @exception.to_s
    end
  end

  class TestRuntimeError < ParfaitTest
    def setup
      @exception = RuntimeError.new
    end

    def test_to_s
      assert_equal 'RuntimeError', @exception.to_s
    end
  end

  class TestTypeError < ParfaitTest
    def setup
      @exception = TypeError.new
    end

    def test_to_s
      assert_equal 'TypeError', @exception.to_s
    end
  end
end
