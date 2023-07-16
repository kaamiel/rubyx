require_relative 'helper'

module SlotMachine
  class TestMatchExceptionClass < SlotMachineInstructionTest
    def instruction
      exception_class_to_match = :RuntimeError
      matched_label = Label.new('matched', 'matched_label')
      MatchExceptionClass.new('_', exception_class_to_match, matched_label: matched_label)
    end

    def test_len
      assert_equal 16, all.length, all_str
    end

    def test_1
      assert_load 1, Parfait::Space, 'id_space_'
    end

    def test_2
      assert_slot_to_reg 2, 'id_space_', 7, 'id_space_.current_exception'
    end

    def test_3
      assert_slot_to_reg 3, 'id_space_.current_exception', 0, 'id_space_.current_exception.type'
    end

    def test_4
      assert_slot_to_reg 4, 'id_space_.current_exception.type', 3, 'id_space_.current_exception.type.object_class'
    end

    def test_5
      assert_label 5, 'Space.current_exception_is_a?_RuntimeError_'
    end

    def test_6
      assert_load 6, Parfait::NilClass, 'id_nilclass_'
    end

    def test_7
      assert_operator 7, :-, 'id_nilclass_', 'id_space_.current_exception.type.object_class', 'op_-_'
    end

    def test_8
      assert_zero 8, 'exit_Space.current_exception_is_a?_RuntimeError_'
    end

    def test_9
      assert_load 9, Parfait::Class, 'id_class_'
    end

    def test_10
      assert_operator 10, :-, 'id_class_', 'id_space_.current_exception.type.object_class', 'op_-_'
    end

    def test_11
      assert_zero 11, 'matched_label'
    end

    def test_12
      assert_slot_to_reg 12, 'id_space_.current_exception.type.object_class', 4, 'id_space_.current_exception.type.object_class.super_class'
    end

    def test_13
      assert_transfer 13, 'id_space_.current_exception.type.object_class.super_class', 'id_space_.current_exception.type.object_class'
    end

    def test_14
      assert_branch 14, 'Space.current_exception_is_a?_RuntimeError_'
    end

    def test_15
      assert_label 15, 'exit_Space.current_exception_is_a?_RuntimeError_'
    end

    def test_to_s
      assert_equal 'MatchExceptionClass RuntimeError', @instruction.to_s
    end
  end
end
