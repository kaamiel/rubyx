require_relative "helper"

module Parfait
  class TestEmptyWord < ParfaitTest

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @word = Parfait::Word.new(0)
    end
    def test_word_create
      assert @word.empty?
    end
    def test_empty_is_zero
      assert_equal 0 , @word.length
    end
    def test_empty_is_zero_internal
      assert_equal 0 , @word.char_length
    end
    def test_index_check_get
      assert_raises ::RuntimeError do
        @word.get_char(0)
      end
    end
    def test_index_check_set
      assert_raises ::RuntimeError do
        @word.set_char(1 , 32)
      end
    end
    def test_insert_1
      a = Parfait.new_word("abc")
      b = Parfait.new_word("d")
      ans = Parfait.new_word("abcd")
      assert_equal ans, a.insert(-1,b)
    end
    def test_insert_2   
      a1 = Parfait.new_word("what name")
      b1 = Parfait.new_word("is your ")
      ans = Parfait.new_word("what is your name")
      assert_equal ans, a1.insert(5, b1)
    end
    def test_insert_3
      a2 = Parfait.new_word("life")
      b2 = Parfait.new_word("sad ")
      ans = Parfait.new_word("sad life")
      assert_equal ans, a2.insert(0, b2) 
    end 
  end
end
