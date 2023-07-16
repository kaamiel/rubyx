require_relative 'helper'

module SlotMachine
  class TestEnsureContinuation < SlotMachineInstructionTest
    def instruction
      standard_label = Label.new('standard', 'standard_label')
      return_label = Label.new('return', 'return_label')
      exception_return_label = Label.new('exception_return', 'exception_return_label')
      EnsureContinuation.new('', standard_label, return_label, exception_return_label)
    end

    def test_len
      assert_equal 11, all.length, all_str
    end

    def test_1
      assert_load 1, Parfait::Space, 'id_space_'
    end

    def test_2
      assert_slot_to_reg 2, 'id_space_', 8, 'id_space_.ensure_list'
    end

    def test_3
      assert_slot_to_reg 3, 'id_space_.ensure_list', 3, 'id_space_.ensure_list.marker'
    end

    def test_4
      assert_slot_to_reg 4, 'id_space_.ensure_list.marker', 2, 'id_space_.ensure_list.marker.data_1'
    end

    def test_5
      assert_operator 5, :|, 'id_space_.ensure_list.marker.data_1', 'id_space_.ensure_list.marker.data_1', 'op_|_'
    end

    def test_6
      assert_zero 6, 'standard_label'
    end

    def test_7
      assert_data 7, 1
    end

    def test_8
      assert_operator 8, :-, 'id_space_.ensure_list.marker.data_1', 'integer_1', 'op_-_'
    end

    def test_9
      assert_zero 9, 'return_label'
    end

    def test_10
      assert_branch 10, 'exception_return_label'
    end

    def test_to_s
      assert_equal 'EnsureContinuation', @instruction.to_s
    end
  end
end
