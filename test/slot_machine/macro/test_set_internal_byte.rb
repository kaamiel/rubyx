require_relative "helper"

module SlotMachine
  module Builtin
    class TestSetInternalByte < BootTest
      def setup
        super
        @method = get_compiler("Word",:set_byte)
      end
      def test_slot_length
        assert_equal :set_internal_byte , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 20 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg 1 ,:message , 12 , "message.arg2"
        assert_reg_to_slot 2 , "message.arg2" , :message , 5
        assert_slot_to_reg 3 ,:message , 11 , "message.arg1"
        assert_slot_to_reg 4 ,"message.arg1" , 2 , "message.arg1.data_1"
        assert_slot_to_reg 5 ,:message , 2 , "message.receiver"
        assert_slot_to_reg 6 ,:message , 12 , "message.arg2"
        assert_slot_to_reg 7 ,"message.arg2" , 2 , "message.arg2.data_1"
        assert_equal Risc::RegToByte , risc(8).class
        assert_slot_to_reg 9 ,:message , 5 , "message.return_value"
        assert_reg_to_slot 10 , "message.return_value" , :message , 5
        assert_branch 11 , "return_label"
        assert_label 12 , "return_label"
      end
      def test_return
        assert_return(12)
      end
    end
  end
end
