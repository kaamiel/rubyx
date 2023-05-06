require_relative "../helper"

module Risc
  module CollectT
    include ScopeHelper

    def boot( num )
      opt = Parfait.default_test_options
      if(num)
        opt[:Integer] = 400
        opt[:Message] = 400
      end
      compiler = compiler_with_main({parfait: opt})
      @linker = compiler.to_target( :arm)
    end

    def test_simple_collect
      objects = Collector.collect_space(@linker)
      assert_equal len , objects.length , objects.length.to_s
    end

    def test_integer_positions
      objects = Collector.collect_space(@linker)
      int = Parfait.object_space.get_next_for(:Integer)
      count = 0
      while(int)
        count += 1
        assert Position.set?(int) , "INT #{int.object_id.to_s(16)} , count #{count}"
        int = int.next_integer
      end
    end
  end
  class TestCollector < MiniTest::Test
    include CollectT

    def setup
      boot(nil)
    end

    def len
      1427
    end

    def test_collect_all_types
      Collector.collect_space(@linker).each do |objekt , position|
        next unless objekt.is_a?( Parfait::Type )
        assert Parfait.object_space.types[ objekt.hash]  , objekt.hash
      end
    end

    def test_allowed_types
      Collector.collect_space(@linker).each do |objekt , position|
        next if objekt.is_a?( Parfait::Object )
        next if objekt.is_a?( Symbol )
        assert false , objekt.class.name
      end
    end
    def test_positions
      Collector.collect_space(@linker).each do |objekt , position|
        assert_equal Position , position.class
        assert !position.valid? , objekt.class.name
      end
    end
  end
  class TestBigCollector < MiniTest::Test
    include CollectT

    def setup
      boot(400)
    end

    def len
      2907
    end
  end
end
