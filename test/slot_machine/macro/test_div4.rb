require_relative "helper"

module SlotMachine
  module Builtin
    class TestIntDiv4Risc < BootTest
      def setup
        @method = get_compiler("Integer",:div4)
      end
      def test_slot_length
        assert_equal :div4 , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
        assert_equal :div4 , @method.callable.name
      end
      def test_risc_length
        assert_equal 37 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_return
        assert_return(32)
      end
      def test_all
        a = Risc.allocate_length
        assert_slot_to_reg a + 1 , :message , 2 , "message.receiver"
        assert_slot_to_reg a + 2 , "message.receiver" , 2 , "message.receiver.data_1"
        assert_data a + 3 , 2
        assert_operator a + 4 , :>> , "message.receiver.data_1" , :integer_1 ,"op_>>_"
        assert_reg_to_slot a + 5 ,"op_>>_" , "id_factory_.next_object" , 2
        assert_reg_to_slot a + 6 ,"id_factory_.next_object" , :message , 5
        assert_slot_to_reg a + 7 , :message , 5 , "message.return_value"
        assert_slot_to_reg a + 8 , :message , 6 , "message.caller"
        assert_reg_to_slot a + 9 , "message.return_value" , "message.caller" , 5
        assert_branch a + 10 , "return_label"
      end
    end
  end
end
