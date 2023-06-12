require_relative "helper"

module SlotMachine
  class TestArgumentTransfer < SlotMachineInstructionTest
    def instruction
      receiver = SlottedMessage.new( [:arg1])
      arg = SlottedMessage.new( [:receiver , :type])
      ArgumentTransfer.new("" , receiver ,[arg])
    end
    def test_len
      assert_equal 11, all.length, all_str
    end
    def test_1_slot
      assert_slot_to_reg 1, :message, 11, :"message.arg1"
    end
    def test_2_slot
      assert_slot_to_reg 2, :message, 1, :"message.next_message"
    end
    def test_3_reg
      assert_reg_to_slot 3, :"message.arg1", :"message.next_message", 2
    end
    def test_4_load
      assert_load 4, Parfait::Integer, 'id_integer_'
    end
    def test_5_slot
      assert_slot_to_reg 5, :message, 1, :"message.next_message"
    end
    def test_6_reg
      assert_reg_to_slot 6, 'id_integer_', :"message.next_message", 10
    end
    def test_7_slot
      assert_slot_to_reg 7, :message, 2, :"message.receiver"
    end
    def test_8
      assert_slot_to_reg 8, :"message.receiver", 0, :"message.receiver.type"
    end
    def test_9
      assert_slot_to_reg 9, :message, 1, :"message.next_message"
    end
    def test_10
      assert_reg_to_slot 10, :"message.receiver.type", :"message.next_message", 11
    end
  end
end
