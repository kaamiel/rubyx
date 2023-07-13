require_relative "helper"

module SlotMachine
  class TestSlotCollection < MiniTest::Test
    include SlotMachineCompile

    def setup
      @comp = compile_slot( "class Test ; def main(); return 'Hi'; end; end;")
    end

    def test_class
      assert_equal SlotCollection , @comp.class
    end
    def test_compilers
      assert_equal 3 , @comp.compilers.num_compilers
    end
    def test_init_compilers
      assert_equal SlotCollection , @comp.init_compilers.class
    end
    def test_compilers_bare
      assert_equal 2 , SlotCollection.new.compilers.num_compilers
    end
    def test_append_class
      assert_equal SlotCollection,  (@comp.append @comp).class
    end
  end
  class TestSlotCollectionToRisc < MiniTest::Test
    include SlotMachineCompile

    def setup
      @comp = compile_slot( "class Space ; def main(); return 'Hi'; end; end;")
      @collection = @comp.to_risc()
    end
    def compiler
      @collection.method_compilers
    end
    def test_has_to_risc
      assert_equal Risc::RiscCollection, @collection.class
    end
    def test_has_risc_compiler
      assert_equal Risc::MethodCompiler, compiler.class
      assert_equal 3, @collection.method_compilers.num_compilers
    end
    def test_has_risc_instructions
      assert_equal Risc::Label, compiler.risc_instructions.class
      assert_equal 10, compiler.risc_instructions.length
    end
  end
end
