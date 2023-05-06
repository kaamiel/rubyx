require_relative "helper"

module SlotMachine
  class TestArgumentTransfer < SlotMachineInstructionTest
    def instruction
      receiver = SlottedMessage.new( [:arg1])
      arg = SlottedMessage.new( [:receiver , :type])
      ArgumentTransfer.new("" , receiver ,[arg])
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_slot
      assert_slot_to_reg 1,:message , 11 , :"message.arg1"
    end
    def test_2_slot
      assert_slot_to_reg 2,:message , 1 , :"message.next_message"
    end
    def test_3_reg
      assert_reg_to_slot 3, :"message.arg1" , :"message.next_message" , 2
    end
    def test_4_slot
      assert_slot_to_reg 4,:message , 2 , :"message.receiver"
    end
    def test_5
      assert_slot_to_reg 5,:"message.receiver" , 0 , :"message.receiver.type"
    end
    def test_6
      assert_slot_to_reg 6,:message , 1 , :"message.next_message"
    end
    def test_7
      assert_reg_to_slot 7, :"message.receiver.type" , :"message.next_message" , 11
    end
  end
end
