require_relative "../helper"

module Risc
  class TestTextWriter < MiniTest::Test
    include  ScopeHelper
    def setup
      compiler = compiler_with_main()
      @linker = compiler.to_target( :arm)
    end
    def test_init
      @text_writer = TextWriter.new(@linker)
    end
    def test_write_fails
      @text_writer = TextWriter.new(@linker)
      assert_raises{ @text_writer.write_as_string} #must translate first
    end
  end
  class TestTextWriterPositions < MiniTest::Test
    include  ScopeHelper
    def setup
      compiler = compiler_with_main()
      @linker = compiler.to_target( :arm)
      @linker.position_all
      @linker.create_binary
      @text_writer = TextWriter.new(@linker)
    end
    def test_write_all
      assert @text_writer.write_as_string
    end
    def test_sorted_class
      assert_equal Array ,  @text_writer.sorted_objects.class
    end
    def test_sorted_positions1
      sorted_objects = @text_writer.sorted_objects
      check_positions(sorted_objects)
    end
    def test_sorted_positions2
      sorted_objects = @text_writer.sorted_objects
      sorted_objects.shift
      check_positions(sorted_objects)
    end
    def check_positions(objects)
      objects.each_slice(2) do |l,r|
        next unless r
        next if l.is_a?(Label) || r.is_a?(Label)
        #assert Position.get(l).at < Position.get(r).at , "#{Position.get(l)} < #{Position.get(r)} , #{l.object_id.to_s(16)}, #{r.object_id.to_s(16)}, #{l.class}, #{r.class}"
      end
    end
  end
end
