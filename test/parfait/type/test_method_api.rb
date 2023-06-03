require_relative "../helper"

module Parfait
  class TestMethodApi < ParfaitTest

    def setup
      super
      @try_class = @space.create_class( :Try )
      @try_type = @try_class.instance_type
    end

    def empty_frame
      Parfait::Type.for_hash( { } , @try_class)
    end
    def foo_method( for_class = :Try)
      args = Parfait::Type.for_hash( { bar: :Integer} , @try_class )
      CallableMethod.new( :foo ,@space.get_type_by_class_name(for_class) , args,empty_frame)
    end
    def add_foo_to( clazz = :Try )
      foo = foo_method( clazz )
      assert_equal foo , @space.get_type_by_class_name(clazz).add_method(foo)
      foo
    end
    def object_type
      @space.get_type_by_class_name(:Object)
    end
    def test_new_methods
      assert_equal Parfait::List , @try_type.method_names.class
      assert_equal @try_type.method_names.get_length , @try_type.methods_length
    end
    def test_add_method
      before = @try_type.methods_length
      add_foo_to
      assert_equal 1 , @try_type.methods_length - before
      assert @try_type.method_names.inspect.include?(":foo")
    end
    def test_remove_method
      add_foo_to
      assert @try_type.remove_method(:foo)
    end
    def test_remove_not_there
      assert_raises ::RuntimeError do
         @try_type.remove_method(:foo)
      end
    end
    def test_create_method
      args = Parfait::Type.for_hash( { bar: :Integer} ,  @try_class)
      @try_type.create_method :bar, args , empty_frame
      assert @try_type.method_names.inspect.include?("bar")
    end
    def test_method_get
      add_foo_to
      assert_equal Parfait::CallableMethod , @try_type.get_method(:foo).class
    end
    def test_method_get_nothere
      assert_nil  @try_type.get_method(:foo)
      test_remove_method
      assert_nil  @try_type.get_method(:foo)
    end
    def test_get_instance
      foo = foo_method :Object
      type = @space.get_type_by_class_name(:Object)
      type.add_method(foo)
      assert_equal :foo , type.get_method(:foo).name
    end
    def test_space_get_method
      test_get_instance
      assert_equal :foo , @space.get_method!(:Object , :foo).name
    end
  end
end
