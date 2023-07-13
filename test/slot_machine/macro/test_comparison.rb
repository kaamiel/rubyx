require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntComp1Risc < BootTest
      def setup
        @method = get_compiler("Integer",:lt)
      end
      def test_slot_length
        assert_equal :< , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 23 , @method.to_risc.risc_instructions.length
      end
    end
    class TestIntComp2Risc < BootTest
      def setup
        @method = get_compiler("Integer",:gt)
      end
      def test_slot_length
        assert_equal :> , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 23 , @method.to_risc.risc_instructions.length
      end
      def test_all
        assert_slot_to_reg 1 , :message , 2 , "message.receiver"
        assert_slot_to_reg 2 , "message.receiver" , 2 , "message.receiver.data_1"
        assert_slot_to_reg 3 ,:message , 11 , "message.arg1"
        assert_slot_to_reg 4 , "message.arg1" , 2 , "message.arg1.data_1"
        assert_operator 5 , :- , "message.receiver.data_1" , "message.arg1.data_1" ,"op_-_"
        assert_minus 6 , "false_label_"
        assert_zero 7 , "false_label_"
        assert_load 8 , Parfait::TrueClass , :result
        assert_branch 9 , "merge_label_"
        assert_label 10 , "false_label_"
        assert_load 11 , Parfait::FalseClass , :result
        assert_label 12 , "merge_label_"
        assert_reg_to_slot 13 , :result , :message , 5
        assert_slot_to_reg 14 ,:message , 5 , "message.return_value"
        assert_slot_to_reg 15 ,:message , 6 , "message.caller"
        assert_reg_to_slot 16 , "message.return_value" , "message.caller" , 5
        assert_branch 17 , "return_label"
      end
      def test_return
        assert_return(18)
      end
    end
  end
end
