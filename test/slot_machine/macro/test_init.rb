require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectInitRisc < BootTest
      def setup
        compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
        coll = compiler.ruby_to_slot( get_preload("Space.main") )
        @method = SlotCollection.create_init_compiler
      end
      def test_slot_length
        assert_equal :__init__ , @method.callable.name
        assert_equal 2 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 25 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_load 1 , Parfait::Factory , "id_factory_"
        assert_slot_to_reg 2 , "id_factory_" , 2 , :message
        assert_slot_to_reg 3 ,:message , 1 , "message.next_message"
        assert_reg_to_slot 4 , "message.next_message" , "id_factory_" , 2
        assert_load 5 , Parfait::CallableMethod , "id_callablemethod_"
        assert_slot_to_reg 6 ,:message , 1 , "message.next_message"
        assert_reg_to_slot 7 , "id_callablemethod_" , "message.next_message" , 7
        assert_slot_to_reg 8, :message, 1, "message.next_message"
        assert_reg_to_slot 9, :message, "message.next_message", 9
        assert_slot_to_reg 10 ,:message , 1 , :message
        assert_load 11, Risc::Label, "id_label_"
        assert_reg_to_slot 12, "id_label_", :message, 8
        assert_load 13 , Parfait::Space , "id_space_"
        assert_reg_to_slot 14 , "id_space_" , :message , 2
        assert_load 15 , Risc::Label , "id_label_"
        assert_reg_to_slot 16 , "id_label_" , :message , 4
        assert_function_call 17 , :main
        assert_label 18 , "__init__.handle_top_level_exception"
        assert_label 19 , "Object.__init__"
        assert_transfer 20 , :message , :saved_message
        assert_slot_to_reg 21 ,:message , 5 , :"message.return_value"
        assert_slot_to_reg 22 ,:"message.return_value" , 2 , "message.return_value.data_1"
        assert_transfer 23 , "message.return_value.data_1" , :syscall_1
        assert_syscall 24, :exit
      end
    end
  end
end
