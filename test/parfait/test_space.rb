require_relative "helper"

module Parfait
  class TestSpace < ParfaitTest

    def classes
      [:Behaviour ,:BinaryCode,:Block,:CacheEntry,:Callable,:CallableMethod,:Class,
        :DataObject,:Data4,:Data8,:Data16,:Data32,:Dictionary,:Factory, :Integer,:FalseClass,
        :List,:Message, :SingletonClass,:NilClass,:Object,:ReturnAddress,
        :Space,:TrueClass,:Type,:SolMethod,:Word,:EnsureEntry,:Exception,:StandardError,:RuntimeError,:TypeError]
    end

    def test_space_length
      assert_equal 9, @space.get_type.instance_length, @space.get_type.inspect
    end
    def test_singletons
      assert @space.true_object , "No truth"
      assert @space.false_object , "No lies"
      assert @space.nil_object , "No nothing"
    end
    def test_current_exception
      assert_nil @space.current_exception
    end
    def test_ensure_list
      assert_instance_of EnsureEntry, @space.ensure_list
    end
    def space_class
      Parfait.object_space.get_class_by_name(:Space)
    end
    def test_global_space
      assert_equal Parfait::Space , Parfait.object_space.class
    end
    def test_get_class_by_name
      assert_equal Parfait::Class , space_class.class
    end
    def test_get_singleton_class
      assert_equal Parfait::SingletonClass , space_class.single_class.class
    end
    def test_get_type_by_class_name
      assert_equal Parfait::Type , Parfait.object_space.get_type_by_class_name(:Space).class
    end
    def test_get_type_by_class_name_nil
      assert_nil Parfait.object_space.get_type_by_class_name(:Spac)
    end
    def test_classes_class
      classes.each do |name|
        assert_equal :Class , @space.classes[name].get_class.name
        assert_equal Parfait::Class , @space.classes[name].class
      end
    end
    def test_all_classes
      assert_equal classes.length , @space.classes.length , @space.classes.keys.inspect
    end
    def test_word_class
      word = @space.classes[:Word]
      assert word.instance_type
      t_word = @space.types[word.instance_type.hash]
      assert_equal word.instance_type.hash , t_word.hash
      assert_equal word.instance_type.object_id , t_word.object_id
    end
    def test_classes_type
      classes.each do |name|
        assert_equal Parfait::Type , @space.classes[name].get_type.class
      end
    end
    def test_classes_name
      classes.each do |name|
        assert_equal name , @space.classes[name].name
      end
    end
    def test_method_name
      classes.each do |name|
        cl = @space.classes[name]
        cl.method_names.each do |mname|
          method = cl.get_instance_method(mname)
          assert_equal mname , method.name
          assert_equal name , method.for_class.name
        end
      end
    end
    def test_all_singletons
      @space.classes.each do |name , clazz|
        assert clazz.single_class , clazz.name
      end
    end
    def test_has_factory
      assert_equal Dictionary , @space.factories.class
    end
    def test_factory_length
      assert_equal 5 , @space.factories.length
    end
    def test_has_integer_factory
      ints = @space.get_factory_for(:Integer)
      assert_equal Factory , ints.class
      assert_equal :Integer , ints.for_type.class_name
    end
    def test_has_integers
      nekst = @space.get_next_for(:Integer)
      assert_equal Parfait::Integer , nekst.class
      assert_nil nekst.value
    end
    def test_has_next_integer
      nekst = @space.get_next_for(:Integer)
      nekst = @space.get_next_for(:Integer)
      assert_equal Parfait::Integer , nekst.class
    end
    def test_has_addresses
      ret = @space.get_next_for(:ReturnAddress)
      assert_equal Parfait::ReturnAddress , ret.class
      assert_nil ret.value
    end
    def test_has_next_address
      assert_equal Parfait::ReturnAddress , @space.get_next_for(:ReturnAddress).class
    end
    def test_has_message_factory
      ints = @space.get_factory_for(:Message)
      assert_equal Factory , ints.class
      assert_equal :Message , ints.for_type.class_name
    end
    def test_has_messages
      nekst = @space.get_next_for(:Message)
      assert_equal Parfait::Message , nekst.class
    end
    def test_has_next_message
      assert_equal Parfait::Message , @space.get_next_for(:Message).class
    end
    def test_has_exception_factory
      ints = @space.get_factory_for(:Exception)
      assert_equal Factory, ints.class
      assert_equal :Exception, ints.for_type.class_name
    end
    def test_has_next_exception
      assert_equal Parfait::Exception, @space.get_next_for(:Exception).class
    end
    def test_has_ensure_entry_factory
      ints = @space.get_factory_for(:EnsureEntry)
      assert_equal Factory, ints.class
      assert_equal :EnsureEntry, ints.for_type.class_name
    end
    def test_has_next_entry
      assert_equal Parfait::EnsureEntry, @space.get_next_for(:EnsureEntry).class
    end

    def test_create_class
      assert @space.create_class( :NewClass )
    end

    def test_created_class_is_stored
      clazz = @space.create_class( :NewerClass )
      assert @space.get_class_by_name(:NewerClass)
    end

  end
  class BigTestSpace < BigParfaitTest
    def test_address_count
      addr = @space.get_next_for(:ReturnAddress)
      count = 0
      while(addr)
        count += 1
        addr = addr.next_integer
      end
      assert_equal 1009, count
    end
    def test_message_count
      mess = @space.get_next_for(:Message)
      count = 0
      while(mess)
        count += 1
        assert mess.locals_used
        mess = mess.next_message
      end
      assert_equal 285, count
    end
  end

end
