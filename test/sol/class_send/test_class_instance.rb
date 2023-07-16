require_relative "helper"

module Sol
  class TestClassInstance < MiniTest::Test
    include SlotMachine
    include SolCompile

    def class_main
      <<-eos
        class Space
          def self.some_inst
            return @inst
          end
          def main(arg)
            return Space.some_inst
          end
        end
      eos
    end

    def setup
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(class_main)
      @compiler = ret.compilers.find_compiler_name(:some_inst)
      @main = ret.compilers.find_compiler_name(:main)
      @ins = @compiler.slot_instructions.next
    end
    def test_class_inst
      space_class = Parfait.object_space.get_class
      assert_equal :Space , space_class.name
      names = space_class.single_class.instance_type.names
      assert names.index_of(:inst) , names
    end
    def test_compiler
      assert_equal SlotMachine::MethodCompiler, @compiler.class
      assert_equal Parfait::Type, @compiler.callable.self_type.class
      assert_equal 6, @compiler.callable.self_type.names.index_of(:inst) , @compiler.callable.self_type.names
    end
    def test_array
      check_array [SlotLoad, ReturnJump, Label, ReturnSequence, Label]  , @ins
    end
    def test_main_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, ReturnJump ,
                    Label, ReturnSequence, Label]  , @main.slot_instructions.next
    end
    def test_main_args
      args = @main.slot_instructions.next(2)
      assert_equal Parfait::Class , args.receiver.known_object.class
      assert_equal :Space , args.receiver.known_object.name
      assert_equal :some_inst , args.receiver.known_object.type.method_names.first
      assert_equal :inst , args.receiver.known_object.type.names.last
    end
    def test_load_inst
      assert_equal SlotLoad,  @ins.class
    end
    def test_left
      assert_equal SlottedMessage , @ins.left.class
      assert_equal :caller , @ins.left.slots.name
    end
    def test_right
      assert_equal SlottedMessage , @ins.right.class
      assert_equal "receiver.inst" , @ins.right.slots.to_s
    end
  end
end
