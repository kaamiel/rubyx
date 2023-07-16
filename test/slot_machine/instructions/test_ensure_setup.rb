require_relative 'helper'

module SlotMachine
  class TestEnsureSetup < SlotMachineInstructionTest
    def instruction
      EnsureSetup.new('', SlotMachine::Slotted.for(SlotMachine::IntegerConstant.new(0)))
    end

    def test_len
      assert_equal 5, all.length, all_str
    end

    def test_1
      assert_load 1, Parfait::Integer, 'id_integer_'
    end

    def test_2
      assert_load 2, Parfait::Space, 'id_space_'
    end

    def test_3
      assert_slot_to_reg 3, 'id_space_', 8, 'id_space_.ensure_list'
    end

    def test_4
      assert_reg_to_slot 4, 'id_integer_', 'id_space_.ensure_list', 3
    end

    def test_to_s
      assert_equal 'EnsureSetup 0', @instruction.to_s
    end
  end
end
