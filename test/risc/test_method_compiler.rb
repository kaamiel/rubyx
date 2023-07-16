require_relative "helper"

module Risc
  class TestMethodCompiler < MiniTest::Test
    include ScopeHelper

    def setup
      code = in_Test("def meth; @ivar = 5;return ;end")
      rubyx = RubyX::RubyXCompiler.new(RubyX.default_test_options)
      @compiler = rubyx.ruby_to_slot(code).compilers.to_risc
    end
    def test_compiles_risc
      assert_equal Risc::MethodCompiler , @compiler.class
      assert_equal Risc::Label , @compiler.risc_instructions.class
    end
    def test_compiles_all_risc
      assert_equal Risc::LoadConstant , @compiler.risc_instructions.next.class
      assert_equal 13 , @compiler.risc_instructions.length
    end
    def test_translate_cpu
      cpu = @compiler.translate_cpu(Platform.for(:arm).translator)
      assert_equal Assembler , cpu.class
      assert_equal :meth , cpu.callable.name
    end
    def test_translate_method
      ass = @compiler.translate_method(Platform.for(:arm) , [])
      assert_equal Array , ass.class
      assert_equal Assembler , ass.first.class
      assert_equal :meth , ass.first.callable.name
    end
  end
end
