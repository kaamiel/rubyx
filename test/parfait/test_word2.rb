require_relative "helper"

module Parfait
  class TestWord < ParfaitTest
    def setup
      super
      @word = Parfait::Word.new(5)
    end

    def test_len
      assert_equal 5 , @word.length
    end
    def test_len_internal
      assert_equal 5 , @word.char_length
    end
    def test_first_char
      assert_equal 32 , @word.get_char(1)
    end
    def test_equals_copy
      assert_equal @word.copy , @word
    end
    def test_equals_copy2
      @word.set_char(0 , 2)
      @word.set_char(4 , 6)
      assert_equal @word.copy , @word
    end
    def test_equals_same
      assert_equal ::Parfait::Word.new(5) , @word
    end
    def test_index_check_get
      assert_raises ::RuntimeError do
        @word.get_char(-6)
      end
    end
    def test_index_check_set
      assert_raises ::RuntimeError do
        @word.set_char(6 , 32)
      end
    end
    def test_index_check_get
      assert_raises ::RuntimeError do
        @word.get_char(6)
      end
    end
    def test_index_check_set
      assert_raises ::RuntimeError do
        @word.set_char(-6 , 32)
      end
    end
    def test_one_char
      assert_equal 32 , @word.set_char(1 , 32)
    end
    def test_one_char_doesnt_cause_problems
      @word.set_char(1 , 32)
      assert_equal 32 , @word.get_char(1)
    end
    def test_one_set1
      assert_equal 44 , @word.set_char(1, 44 )
    end
    def test_two_sets
      assert_equal 1 , @word.set_char(1,1)
      assert_equal 44 , @word.set_char(1,44)
    end
    def test_one_get1
      test_one_set1
      assert_equal 44 , @word.get_char(1)
    end
    def test_many_get
      shouldda  = { 1 => 11 , 2 => 22 , 3 => 33}
      shouldda.each do |k,v|
        @word.set_char(k,v)
      end
      shouldda.each do |k,v|
        assert_equal v , @word.get_char(k)
      end
    end
    def test_not_same
      one = Parfait.new_word("one")
      two = Parfait.new_word("two")
      assert !one.compare(two)
    end
    def test_is_same
      one = Parfait.new_word("one")
      two = Parfait.new_word("one")
      assert one.compare(two)
    end

    def test_start_with1
      one = Parfait.new_word("Hello")
      two = Parfait.new_word("Hel")
      assert one.start_with(two)
    end
    def test_start_with2
      one = Parfait.new_word("Vanilla")
      two = Parfait.new_word("Va")
      assert one.start_with(two)
    end
    def test_start_with3
      one = Parfait.new_word("hello")
      two = Parfait.new_word("hellooo")
      assert_equal false, one.start_with(two)
    end
    def test_start_with4
      one = Parfait.new_word("bajjs")
      two = Parfait.new_word("bgjj")
      assert_equal false, one.start_with(two)
    end

    def test_first_char
      one = Parfait.new_word("one")
      one.set_char(0 , "T".ord)
      assert_equal "Tne" , one.to_string
    end
    def test_sec_char
      one = Parfait.new_word("one")
      one.set_char(1 , "m".ord)
      assert_equal "ome" , one.to_string
    end
    def test_more_char
      one = Parfait.new_word("one")
      assert_raises {one.set_char(3 , "s".ord)}
    end
    def test_max
      str = "12345678901234567890"
      one = Parfait.new_word(str)
      assert_equal str , one.to_string
      assert_equal 20 , one.length
    end

  end
end
