require_relative "../helper"

module Risc
  class TestLinkerObjects < MiniTest::Test
    include ScopeHelper
    def setup
      compiler = compiler_with_main()
      @linker = compiler.to_target( :arm)
    end
    def test_objects
      objects = @linker.object_positions
      assert_equal Hash , objects.class
      assert 350 < objects.length
    end
    def test_constant_fail
      assert_raises {@machine.add_constant( 1 )}
    end
  end
  class TestLinkerInit < MiniTest::Test
    def setup
      @linker = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_binary("class Space;def main;return 1;end;end",:arm)
    end
    def test_pos_cpu
      assert_equal 0 ,  Position.get(@linker.cpu_init).at
    end
    def test_cpu_at
      assert_equal "0x95bc", Position.get(@linker.cpu_init.first).to_s
    end
    def test_cpu_label
      assert_equal Position ,  Position.get(@linker.cpu_init.first).class
    end
    def test_first_binary_jump
      bin = Parfait.object_space.get_method!(:Object,:__init__).binary
      assert_equal 116 , bin.total_byte_length
    end
    def test_second_binary_first
      bin = Parfait.object_space.get_method!(:Object,:__init__).binary
      assert 0 != bin.get_word(0) , "index 0 is 0 #{bin.inspect}"
    end
    def test_positions_set
      @linker.object_positions.each do |obj,position|
        assert position.valid? , "#{position} #{position.object.class}, #{obj.object_id.to_s(16)}"
      end
    end
  end
end
