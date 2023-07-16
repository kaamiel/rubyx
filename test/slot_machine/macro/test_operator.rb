require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntOpPl < BootTest
      def setup
        @method = get_compiler("Integer",:and)
      end
      def test_slot_length
        assert_equal :& , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 38 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntOpMM < BootTest
      def setup
        @method = get_compiler("Integer",:or)
      end
      def test_slot_length
        assert_equal :| , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 38 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        s = Risc.allocate_length
        assert_slot_to_reg s + 1 ,:message , 2 , "message.receiver"
        assert_slot_to_reg s + 2 ,"message.receiver" , 2 , "message.receiver.data_1"
        assert_slot_to_reg s + 3 ,:message , 11 , "message.arg1"
        assert_slot_to_reg s + 4 , "message.arg1" , 2 , "message.arg1.data_1"
        assert_operator s + 5 , :| , "message.receiver.data_1" , "message.arg1.data_1" , "op_|_"
        assert_reg_to_slot s + 6 , "op_|_"  , "id_factory_.next_object" , 2
        assert_reg_to_slot s + 7 , "id_factory_.next_object"  , :message , 5
        assert_slot_to_reg s + 8 ,:message , 5 , "message.return_value"
        assert_slot_to_reg s + 9 ,:message , 6 , "message.caller"
        assert_reg_to_slot s + 10 , "message.return_value"  , "message.caller" , 5
        assert_branch s + 11 , "return_label"
        assert_label s + 12 , "return_label"
      end
      def test_return
        assert_return(33)
      end
    end
  end
end
