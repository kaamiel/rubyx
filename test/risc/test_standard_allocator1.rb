require_relative "../helper"

module Risc
  class TestStandardAllocator1 < MiniTest::Test
    include SlotMachineCompile
    def setup
      coll = compile_slot( "class Space ; def main(); main{return 'Ho'};return 'Hi'; end; end;")
      @compiler = coll.to_risc.method_compilers
      @allocator = Platform.for(:arm).allocator(@compiler)
    end
    def test_main
      assert_equal :main , @compiler.callable.name
    end
    def test_allocate_runs
      assert_nil @allocator.allocate_regs
      assert_equal 0 , @allocator.used_regs.length
    end
    def test_live_length
      live = @allocator.walk_and_mark(@compiler.risc_instructions)
      assert_equal 13 , live.length
    end
    def test_ssa
      instruction = @compiler.risc_instructions.next(2)
      assert_equal :"message.next_message" , instruction.register.symbol
    end
    def est_risc
      assert_nil @allocator.allocate_regs
      instruction = @compiler.risc_instructions.next(2)
      assert_equal :"message.next_message" , instruction.register.symbol
    end
  end
end
