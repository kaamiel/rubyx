require_relative "helper"

module SlotMachine
  class TesBlockYield < SlotMachineInstructionTest
    def instruction
      BlockYield.new("source",1)
    end
    def test_len
      assert_equal 8 , all.length , all_str
    end
    def test_1_load
      assert_load 1, Risc::Label , "id_"
      assert_label risc(1).constant , "continue_" ,1
    end
    def test_2_slot
      assert_slot_to_reg 2,:message , 1 , "message.next_message"
    end
    def test_3_reg
      assert_reg_to_slot 3, "id_" , "message.next_message" , 4
    end
    def test_4_slot
      assert_slot_to_reg 4,:message , 11 , "message.arg1"
    end
    def test_5_swap
      assert_slot_to_reg 5,:message , 1 , :message
    end
    def test_6_jump
      assert_equal Risc::DynamicJump , risc(6).class
      assert_equal :"message.arg1" ,  risc(6).register.symbol
    end
    def test_7_label
      assert_label 7, "continue_"
    end
  end
end
