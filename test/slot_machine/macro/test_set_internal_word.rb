require_relative "helper"

module SlotMachine
  module Builtin
    class TestSetInternalWord < BootTest
      def setup
        @method = get_compiler("Word",:set)
      end
      def test_slot_length
        assert_equal :set_internal_word , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 16 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg 1 ,:message , 11 , "message.arg1"
        assert_slot_to_reg 2 ,"message.arg1" , 2 , "message.arg1.data_1"
        assert_slot_to_reg 3 ,:message , 12 , "message.arg2"
        assert_slot_to_reg 4 ,:message , 2 , "message.receiver"
        assert_reg_to_slot 5 , "message.arg2" , "message.receiver" , :"message.arg1.data_1"
        assert_reg_to_slot 6 , "message.arg2" , :message , 5
        assert_slot_to_reg 7 ,:message , 5 , :"message.return_value"
        assert_slot_to_reg 8 ,:message , 6 , :"message.caller"
        assert_reg_to_slot 9 , "message.return_value" , "message.caller" , 5
        assert_branch 10 , "return_label"
      end
      def test_return
        assert_return(11)
      end
    end
  end
end
