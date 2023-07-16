require_relative 'helper'

module SlotMachine
  class TestIsKindOf < SlotMachineInstructionTest
    def instruction
      object_class = Slotted.for(Parfait::Dictionary.new)
      klass = Parfait.object_space.get_class_by_name(:CallableMethod)
      true_label = Label.new('true', 'true_label')
      false_label = Label.new('false', 'false_label')
      IsKindOf.new(object_class, klass, true_label: true_label, false_label: false_label)
    end

    def test_len
      assert_equal 14, all.length, all_str
    end

    def test_1
      assert_load 1, Parfait::Dictionary, 'id_dictionary_'
    end

    def test_2
      assert_slot_to_reg 2, 'id_dictionary_', 0, 'id_dictionary_.type'
    end

    def test_3
      assert_slot_to_reg 3, 'id_dictionary_.type', 3, 'id_dictionary_.type.object_class'
    end

    def test_4
      assert_label 4, 'Dictionary_is_a?_CallableMethod_'
    end

    def test_5
      assert_load 5, Parfait::NilClass, 'id_nilclass_'
    end

    def test_6
      assert_operator 6, :-, 'id_nilclass_', 'id_dictionary_.type.object_class', 'op_-_'
    end

    def test_7
      assert_zero 7, 'false_label'
    end

    def test_8
      assert_load 8, Parfait::Class, 'id_class_'
    end

    def test_9
      assert_operator 9, :-, 'id_class_', 'id_dictionary_.type.object_class', 'op_-_'
    end

    def test_10
      assert_zero 10, 'true_label'
    end

    def test_11
      assert_slot_to_reg 11, 'id_dictionary_.type.object_class', 4, 'id_dictionary_.type.object_class.super_class'
    end

    def test_12
      assert_transfer 12, 'id_dictionary_.type.object_class.super_class', 'id_dictionary_.type.object_class'
    end

    def test_13
      assert_branch 13, 'Dictionary_is_a?_CallableMethod_'
    end

    def test_to_s
      assert_equal 'IsKindOf Dictionary.is_a? CallableMethod', @instruction.to_s
    end
  end
end
