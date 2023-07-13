require_relative "helper"

module SlotMachine
  module Builtin
    class TestWordPutRisc < BootTest
      def setup
        @method = get_compiler("Word",:put)
      end
      def test_slot_length
        assert_equal :putstring , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 42 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        s = Risc.allocate_length
        assert_reg_to_slot s + 1 , "id_factory_.next_object"  , :message , 5
        assert_slot_to_reg s + 2 ,:message , 2 , "message.receiver"
        assert_slot_to_reg s + 3 ,"message.receiver" , 1 , "id_factory_.next_object"
        assert_transfer s + 4 , :"message.receiver" , :syscall_2
        assert_transfer s + 5 , "id_factory_.next_object" , :syscall_3
        assert_transfer s + 6 , :message , :saved_message
        assert_syscall s + 7 , :putstring
        assert_transfer s + 8 , :syscall_1 , :restore_integer_return
        assert_transfer s + 9 , :saved_message , :message
        assert_slot_to_reg s + 10 ,:message , 5 , "message.return_value"
        assert_reg_to_slot s + 11 , :restore_integer_return  , "message.return_value" , 2
        assert_slot_to_reg s + 12 ,:message , 5 , "message.return_value"
        assert_slot_to_reg s + 13 ,:message , 6 , "message.caller"
        assert_reg_to_slot s + 14 , "message.return_value"  , "message.caller" , 5
        assert_branch s + 15 , "return_label"
        assert_label s + 16 , "return_label"
      end
      def test_return
        assert_return(37)
      end
    end
  end
end
