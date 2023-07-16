require_relative 'helper'

module Parfait
  class TestEnsureEntry < ParfaitTest
    def setup
      @ensure_entry = EnsureEntry.new
    end

    def test_to_s
      assert_equal 'EnsureEntry', @ensure_entry.to_s
    end
  end
end
