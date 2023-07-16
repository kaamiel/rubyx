require_relative "helper"

module SlotMachine
  class TestReturnSequence < SlotMachineInstructionTest
    def instruction
      ReturnSequence.new("source")
    end
    def test_len
      assert_equal 4 , all.length , all_str
    end
    def test_1_load_return_address
      assert_slot_to_reg 1,:message , 4 , "message.return_address"
    end
    def test_2_swap_messages
      assert_slot_to_reg 2,:message, 6 , :message
    end
    def test_3_do_return
      assert_equal Risc::FunctionReturn , risc(3).class
      assert_equal :"message.return_address" , risc(3).register.symbol
    end
  end
end
