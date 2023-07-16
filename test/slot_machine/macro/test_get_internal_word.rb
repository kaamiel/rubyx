require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordGetRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:get)
      end
      def test_slot_length
        assert_equal :get_internal_word , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 17 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg 1 ,:message , 11 , "message.arg1"
        assert_slot_to_reg 2 , "message.arg1" , 2 , "message.arg1.data_1"
        assert_slot_to_reg 3 , :message , 2 , "message.receiver"
        assert_slot_to_reg 4 , :"message.receiver" , :"message.arg1.data_1" , "message.receiver.indexed"
        assert_reg_to_slot 5 , "message.receiver.indexed" , :message , 5
        assert_slot_to_reg 6 , :message , 5 , "message.return_value"
        assert_reg_to_slot 7 , "message.return_value" , :message , 5
        assert_branch 8 , "return_label"
        assert_label 9 , "return_label"
      end
      def test_return
        assert_return(9)
      end
    end
  end
end
