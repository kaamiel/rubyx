require_relative "helper"

module SlotMachine
  module Builtin
    class TestObjectExitRisc < BootTest
      def setup
        super
        @method = get_compiler("Object",:exit)
      end
      def test_slot_length
        assert_equal :exit , @method.callable.name
        assert_equal 7 , @method.slot_instructions.length
      end
      def test_compile
        assert_equal Risc::MethodCompiler , @method.to_risc.class
      end
      def test_risc_length
        assert_equal 37 , @method.to_risc.risc_instructions.length
      end
      def test_allocate
        assert_allocate
      end
      def test_all
        a = Risc.allocate_length
        assert_reg_to_slot a + 1 , "id_factory_.next_object"  , :message , 5
        assert_transfer a + 2 , :message , :saved_message
        assert_slot_to_reg a + 3 ,:message , 5 , :"message.return_value"
        assert_slot_to_reg a + 4 ,:"message.return_value" , 2 , "message.return_value.data_1"
        assert_transfer a + 5 , :"message.return_value.data_1" , :syscall_1
        assert_syscall a + 6 , :exit
        assert_slot_to_reg a + 7 ,:message , 5 , "message.return_value"
        assert_slot_to_reg a + 8 ,:message , 6 , "message.caller"
        assert_reg_to_slot a + 9 , "message.return_value"  , "message.caller" , 5
        assert_branch a + 10 , "return_label"
        assert_label a + 11 , "return_label"
      end
      def test_return
        assert_return(32)
      end
    end
  end
end
