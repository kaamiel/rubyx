require_relative 'helper'

module SlotMachine
  module Builtin
    class TestObjectRaiseRisc < BootTest
      def setup
        @method = get_compiler(:Object, :raise)
      end

      def test_slot_length
        assert_equal :raise, @method.callable.name
        assert_equal 7, @method.slot_instructions.length
      end

      def test_compile
        assert_equal Risc::MethodCompiler, @method.to_risc.class
      end

      def test_risc_length
        assert_equal 59, @method.to_risc.risc_instructions.length
      end

      def test_allocate
        assert_load 1, Parfait::Factory, 'id_factory_'
        assert_slot_to_reg 2, 'id_factory_', 2, 'id_factory_.next_object'
        assert_slot_to_reg 3, 'id_factory_.next_object', 2, 'id_factory_.next_object.next_exception'
        assert_reg_to_slot 4, 'id_factory_.next_object.next_exception', 'id_factory_', 2
      end

      def test_all
        a = 4
        assert_slot_to_reg a + 1, :message, 10, 'message.arguments_given'
        assert_slot_to_reg a + 2, 'message.arguments_given', 2, 'message.arguments_given.data_1'
        assert_operator a + 3, :|, 'message.arguments_given.data_1', 'message.arguments_given.data_1', 'op_|_'
        assert_zero a + 4, 'raise_no_args_'

        assert_slot_to_reg a + 5, :message, 11, 'message.arg1'
        assert_label a + 6, 'message.arg1:Class_is_a?_Exception_'
        assert_load a + 7, Parfait::NilClass, 'id_nilclass_'
        assert_operator a + 8, :-, 'id_nilclass_', 'message.arg1', 'op_-_'
        assert_zero a + 9, 'raise_type_error_'
        assert_load a + 10, Parfait::Class, 'id_class_'
        assert_operator a + 11, :-, 'id_class_', 'message.arg1', 'op_-_'
        assert_zero a + 12, 'exit_message.arg1:Class_is_a?_Exception_'
        assert_slot_to_reg a + 13, 'message.arg1', 4, 'message.arg1.super_class'
        assert_transfer a + 14, 'message.arg1.super_class', 'message.arg1'
        assert_branch a + 15, 'message.arg1:Class_is_a?_Exception_'
        assert_label a + 16, 'exit_message.arg1:Class_is_a?_Exception_'

        assert_load a + 17, Parfait::Space, 'id_space_'
        assert_slot_to_reg a + 18, :message, 11, 'message.arg1'
        assert_slot_to_reg a + 19, 'message.arg1', 2, 'message.arg1.instance_type'
        assert_reg_to_slot a + 20, 'message.arg1.instance_type', 'id_factory_.next_object', 0
        assert_slot_to_reg a + 21, 'id_space_', 7, 'id_space_.current_exception'
        assert_reg_to_slot a + 22, 'id_space_.current_exception', 'id_factory_.next_object', 1
        assert_reg_to_slot a + 23, 'id_factory_.next_object', 'id_space_', 7
        assert_branch a + 24, 'raise_merge_'

        assert_label a + 25, 'raise_type_error_'
        assert_load a + 26, Parfait::Class, 'id_class_'
        assert_load a + 27, Parfait::Space, 'id_space_'
        assert_slot_to_reg a + 28, 'id_class_', 2, 'id_class_.instance_type'
        assert_reg_to_slot a + 29, 'id_class_.instance_type', 'id_factory_.next_object', 0
        assert_slot_to_reg a + 30, 'id_space_', 7, 'id_space_.current_exception'
        assert_reg_to_slot a + 31, 'id_space_.current_exception', 'id_factory_.next_object', 1
        assert_reg_to_slot a + 32, 'id_factory_.next_object', 'id_space_', 7
        assert_branch a + 33, 'raise_merge_'

        assert_label a + 34, 'raise_no_args_'
        assert_load a + 35, Parfait::Class, 'id_class_'
        assert_load a + 36, Parfait::Space, 'id_space_'
        assert_slot_to_reg a + 37, 'id_class_', 2, 'id_class_.instance_type'
        assert_reg_to_slot a + 38, 'id_class_.instance_type', 'id_factory_.next_object', 0
        assert_slot_to_reg a + 39, 'id_space_', 7, 'id_space_.current_exception'
        assert_reg_to_slot a + 40, 'id_space_.current_exception', 'id_factory_.next_object', 1
        assert_reg_to_slot a + 41, 'id_factory_.next_object', 'id_space_', 7

        assert_label a + 42, 'raise_merge_'
        assert_slot_to_reg a + 43, :message, 8, 'message.exc_return_address'
        assert_slot_to_reg a + 44, :message, 9, :message
        assert_equal Risc::FunctionReturn, risc(a + 45).class

        assert_slot_to_reg a + 46, :message, 5, 'message.return_value'
        assert_slot_to_reg a + 47, :message, 6, 'message.caller'
        assert_reg_to_slot a + 48, 'message.return_value', 'message.caller', 5
        assert_branch a + 49, 'return_label'
        assert_label a + 50, 'return_label'
      end

      def test_return
        assert_return(54)
      end
    end
  end
end
