require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntDiv10Risc < BootTest
      def setup
        @method = get_compiler("Integer",:div10)
      end
      def test_slot_length
        assert_equal :div10 , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 66 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(61)
      end
      def test_all
        a = Risc.allocate_length
        assert_slot_to_reg a + 1 , "message" , 2 , "message.receiver"
        assert_slot_to_reg a + 2 , "message.receiver" , 2 , "message.receiver.data_1"
        assert_transfer a + 3 , "message.receiver.data_1" , "integer_1"
        assert_transfer a + 4 , "message.receiver.data_1" , "integer_reg"
        assert_data a + 5 , 1
        assert_operator a + 6 , :>> , :integer_1 , :integer_const , :integer_1
        assert_data a + 7 , 2
        assert_operator a + 8 , :>> , :integer_reg , :integer_const , :integer_reg
        assert_operator a + 9 , :+ , :integer_reg , :integer_1 , :integer_reg
        assert_data a + 10 , 4
        assert_transfer a + 11 , :integer_reg , :integer_1
        assert_operator a + 12 , :>> , :integer_reg , :integer_1 , :integer_reg
        assert_operator a + 13 , :+ , :integer_reg , :integer_1 , :integer_reg
        assert_data a + 14 , 8
        assert_transfer a + 15 , :integer_reg , :integer_1
        assert_operator a + 16 , :>> , :integer_1 , :integer_const , :integer_1
        assert_operator a + 17 , :+ , :integer_reg , :integer_1 , :integer_reg
        assert_data a + 18 , 16
        assert_transfer a + 19 , :integer_reg , :integer_1
        assert_operator a + 20 , :>> , :integer_1 , :integer_const , :integer_1
        assert_operator a + 21 , :+ , :integer_reg , :integer_1 , :integer_reg
        assert_data a + 22 , 3
        assert_operator a + 23 , :>> , :integer_reg , :integer_const , :integer_reg
        assert_data a + 24 , 10
        assert_transfer a + 25 , :integer_reg , :integer_1
        assert_operator a + 26 , :* , :integer_1 , :integer_const , :integer_1
        assert_operator a + 27 , :- , "message.receiver.data_1" , :integer_1 , "message.receiver.data_1"
        assert_transfer a + 28 , "message.receiver.data_1" , :integer_1
        assert_data a + 29 , 6
        assert_operator a + 30 , :+ , :integer_1 , :integer_const , :integer_1
        assert_data a + 31 , 4
        assert_operator a + 32 , :>> , :integer_1 , :integer_const , :integer_1
        assert_operator a + 33 , :+ , :integer_reg , :integer_1 , :integer_reg
        assert_reg_to_slot a + 34 , :integer_reg , "id_factory_.next_object" , 2
        assert_reg_to_slot a + 35 , "id_factory_.next_object" , :message , 5
        assert_slot_to_reg a + 36 ,:message , 5 , "message.return_value"
        assert_slot_to_reg a + 37 ,:message , 6 , "message.caller"
        assert_reg_to_slot a + 38 , "message.return_value" , "message.caller" , 5
        assert_branch a + 39 , "return_label"
        assert_label a + 40 , "return_label"
      end
    end
  end
end
