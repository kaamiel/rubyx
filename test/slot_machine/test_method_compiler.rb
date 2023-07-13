require_relative "helper"

module SlotMachine
  class TestMethodCompiler < MiniTest::Test
    include ScopeHelper

    def setup
    end

    def in_test_sol(str)
      sol = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_sol(in_Test(str))
      sol.to_parfait
      sol.to_slot(nil)
      sol
    end
    def create_method(body = "@ivar = 5;return")
      in_test_sol("def meth; #{body};end")
      test = Parfait.object_space.get_class_by_name(:Test)
      test.get_instance_method(:meth)
    end

    def test_method_has_source
      method = create_method
      assert_equal Sol::Statements ,  method.source.class
    end

    def test_method_has_no_locals
      method = create_method
      assert_equal 1 , method.frame_type.instance_length
    end

    def test_method_has_no_args
      method = create_method
      assert_equal 1 , method.args_type.instance_length
    end

    def test_creates_method_in_class
      method = create_method
      assert method , "No method created"
      assert_equal Parfait::SolMethod , method.class
    end

    def test_creates_method_statement_in_class
      clazz = in_test_sol("def meth; @ivar = 5 ;return;end")
      assert_equal Sol::Statements , clazz.body.class
      assert_equal Sol::MethodExpression , clazz.body.first.class
    end

    def test_callable_method_instance_type
      in_test_sol("def meth; @ivar = 5; @ibar = 4;return;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.instance_type.get_method(:meth)
      assert_equal 1, method.self_type.variable_index(:ivar)
      assert_equal 2, method.self_type.variable_index(:ibar)
    end
    def test_callable_method_has_one_local
      in_test_sol("def meth; local = 5 ; a = 6;return;end")
      test = Parfait.object_space.get_class_by_name(:Test)
      method = test.get_instance_method(:meth)
      assert_equal 3 , method.frame_type.instance_length
      assert_equal 1 , method.frame_type.variable_index(:local)
      assert_equal 2 , method.frame_type.variable_index(:a)
    end
    def constant_setup(input)
      slot = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_slot(in_Test(input))
      assert_equal SlotMachine::SlotCollection , slot.class
      compiler = slot.method_compilers
      assert_equal SlotMachine::MethodCompiler , compiler.class
      compiler
    end
    def test_return_label
      compiler = constant_setup("def meth; return 'Hi';end")
      assert_equal "return_label", compiler.get_return_label.name
    end
  end
end
