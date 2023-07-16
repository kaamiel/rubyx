require_relative "helper"

module Parfait
  # Most type and method related stuff
  class TestSpaceMethod < ParfaitTest

    def test_types
      assert  @space.types.is_a? Parfait::Dictionary
    end
    def test_types_attr
      assert @space.types.is_a? Parfait::Dictionary
    end
    def test_types_each
      @space.each_type do |type|
        assert type.is_a?(Parfait::Type)
      end
    end
    def test_types_hashes
      types = @space.types
      types.each do |has , type|
        assert has.is_a?(::Integer) , has.class
      end
    end
    def test_classes_types_in_space_types
      @space.classes do |name , clazz|
        assert_equal clazz.instance_type , @space.get_type_for(clazz.instance_type.hash) , clazz.name
      end
    end

    def test_class_types_are_stored
      @space.classes.each do |name,clazz|
        assert @space.types[clazz.instance_type.hash]
      end
    end

    def test_class_types_are_identical
      @space.classes.each do |name , clazz|
        cl_type = @space.types[clazz.instance_type.hash]
        assert_equal cl_type.object_id , clazz.instance_type.object_id , name
      end
    end

    def test_remove_methods
      @space.each_type do | type |
        type.method_names.each do |method|
          type.remove_method(method)
        end
      end
      assert_equal 0 , @space.get_all_methods.length
    end

    def test_no_methods_in_types
      test_remove_methods
      @space.each_type do |type|
        assert_equal 0 , type.methods_length , "name #{type.name}"
      end
    end

    def test_no_methods_in_classes
      test_remove_methods
      @space.classes.each do |name , cl|
        assert_equal 0 , cl.instance_type.methods_length , "name #{cl.name}"
      end
    end

    def test_get_method_raises
      assert_raises(::RuntimeError){ @space.get_method!(:Space,:main)}
    end

  end
end
