require_relative "helper"

module Sol
  class TestYieldArgsSendSlotMachine  < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "return yield(1)" )
      @ins = @compiler.slot_instructions.next
    end

    def test_array
      check_array [NotSameCheck, Label, MessageSetup, ArgumentTransfer, BlockYield ,
                    SlotLoad, ReturnJump, Label, ReturnSequence , Label]  , @ins
    end
    def test_check_label
      assert_equal NotSameCheck, @ins.class
      assert @ins.false_label.name.start_with?("method_ok_") , @ins.false_label.name
    end
    def test_transfer
      assert_equal ArgumentTransfer, @ins.next(3).class
      assert_equal 1, @ins.next(3).arguments.length
    end
    def test_args_one_l
      left = @ins.next(3).arguments[0]
      assert_equal SlotMachine::IntegerConstant, left.known_object.class
    end
    def test_check_left
      assert_equal SlottedObject, @ins.left.class
      assert_equal Parfait::CallableMethod, @ins.left.known_object.class
      assert_equal :main, @ins.left.known_object.name
      assert !@ins.left.slots
    end
    def test_check_right
      assert_equal SlottedMessage, @ins.right.class
      assert_equal :message, @ins.right.known_object
      assert_equal "message.method" , @ins.right.to_s
    end
    def test_label
      assert_equal Label, @ins.next(1).class
      assert @ins.next(1).name.start_with?("method_ok_")
    end
    def test_setup
      assert_equal MessageSetup, @ins.next(2).class
      assert_equal 2, @ins.next(2).method_source
    end
    def test_receiver
      assert_equal :message , @ins.next(3).receiver.known_object
      assert_equal :receiver , @ins.next(3).receiver.slots.name
    end
    def test_yield
      assert_equal BlockYield, @ins.next(4).class
      assert_equal 2, @ins.next(4).arg_index
    end
    def test_return_load
      assert_equal SlotLoad, @ins.next(5).class
      assert_equal :message, @ins.next(5).left.known_object
      assert_equal :message, @ins.next(5).right.known_object
      assert_equal :caller, @ins.next(5).left.slots.name
      assert_equal :return_value, @ins.next(5).right.slots.name
    end
    def test_return
      assert_equal ReturnJump, @ins.next(6).class
    end
  end
  class TestYieldNoArgsSendSlotMachine < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "return yield(some.extra.calls)" )
      @ins = @compiler.slot_instructions.next
    end
    def test_check_label
      assert_equal NotSameCheck, @ins.class
      assert @ins.false_label.name.start_with?("send_cache_some_ok_") , @ins.false_label.name
    end
    def test_array
      check_array [NotSameCheck, SlotLoad, ResolveMethod, Label, MessageSetup ,
                    ArgumentTransfer, DynamicCall, SlotLoad, NotSameCheck, SlotLoad ,
                    ResolveMethod, Label, MessageSetup, ArgumentTransfer, DynamicCall ,
                    SlotLoad, NotSameCheck, SlotLoad, ResolveMethod, Label ,
                    MessageSetup, ArgumentTransfer, DynamicCall, SlotLoad, NotSameCheck ,
                    Label, MessageSetup, ArgumentTransfer, BlockYield, SlotLoad ,
                    ReturnJump, Label, ReturnSequence, Label]  , @ins
    end
    def test_transfer
      assert_equal ArgumentTransfer, @ins.next(5).class
      assert_equal 0, @ins.next(5).arguments.length
    end
  end
end
