module Minitest
  module Assertions
    def assert_tos string , object
      assert_equal string , object.to_s.gsub("\n",";").gsub(/\s+/," ").gsub("; ",";")
    end
    def assert_register( kind , pattern , register , at = 0)
      return unless register
      if(pattern.is_a?(Symbol))
        assert_equal( pattern , register.symbol , "wrong #{kind} register:#{register} , at:#{at}")
      else
        is_parts = pattern.split(".")
        reg_parts = register.symbol.to_s.split(".")
        assert_equal reg_parts.length , is_parts.length , "wrong dot #{kind} length for #{pattern} , at:#{at}"
        is_parts.each_with_index do |part , index|
          assert reg_parts[index].start_with?(part) , "wrong #{kind} part(#{reg_parts[index]}), at index #{index}:#{part}, ins:#{at}"
        end
      end
    end
    def assert_slot_to_reg( slot_i , array = nil, index = nil , register = nil)
      if(slot_i.is_a? Integer)
        slot = risc(slot_i)
      else
        slot = slot_i
        slot_i = :unknown
      end
      assert_equal Risc::SlotToReg , slot.class , "Class at #{slot_i}"
      assert_register( :source , array , slot.array , slot_i)
      if(slot_i == :unknown)
        assert_index( :source , slot , index)
      else
        assert_index( :source , slot_i , index)
      end
      assert_register( :destination , register , slot.register , slot_i )
    end
    def assert_reg_to_slot( slot_i , register = nil, array = nil, index = nil )
      assert_equal Integer , slot_i.class, "assert_reg_to_slot #{slot_i}"
      slot = risc(slot_i)
      assert_equal Risc::RegToSlot , slot.class, "Class at #{slot_i}"
      assert_register( :source , register , slot.register ,  slot_i)
      assert_register( :destination , array , slot.array , slot_i)
      assert_index( :destination , slot_i , index )
    end
    def assert_index(kind , slot_i , index)
      return unless index
      if(slot_i.is_a? Integer)
        slot = risc(slot_i)
      else
        slot = slot_i
        slot_i = :unknown
      end
      if(slot.index.is_a?(Risc::RegisterValue))
        assert_equal( Symbol , index.class, "wrong #{kind} index class, at:#{slot_i}")
        assert_equal( index , slot.index.symbol, "wrong #{kind} index, at#{slot_i}")
      else
        assert_equal( index , slot.index, "wrong #{kind} index, at:#{slot_i}")
      end
    end
    def assert_load(load_i , clazz = nil , register = nil)
      assert_equal Integer , load_i.class, "assert_load #{load_i}"
      load = risc(load_i)
      assert_equal Risc::LoadConstant , load.class
      assert_equal( clazz , load.constant.class) if clazz
      if register
        assert_register(:source , register , load.register)
      else
        raise "add register at:#{load_i}, as third operand at #{load_i}"
      end
    end
    def assert_transfer( transfer_i , from , to)
      assert_equal Integer , transfer_i.class, "assert_transfer #{transfer_i}"
      transfer = risc(transfer_i)
      assert_equal Risc::Transfer , transfer.class, "Class at #{transfer_i}"
      assert_register( :source , from , transfer.from , transfer_i)
      assert_register( :destination , to , transfer.to , transfer_i)
    end
    def assert_label( label_i , name , at = nil)
      if(at)
        label = label_i
        label_i = at
      else
        assert_equal Integer , label_i.class, "assert_label #{label_i}"
        label = risc(label_i)
      end
      assert_equal Risc::Label , label.class, "Class at:#{label_i}"
      if(name[-1] == "_")
        assert label.name.start_with?(name) , "Label at:#{label_i} does not start with #{name}:#{label.name}"
      else
        assert_equal name , label.name , "Label at:#{label_i}"
      end
    end
    def assert_branch( branch_i , label_name )
      assert_equal Integer , branch_i.class, "assert_branch #{branch_i}"
      branch = risc(branch_i)
      assert_equal Risc::Branch , branch.class , "Class at:#{branch_i}"
      assert_label branch.label , label_name , "Label  at #{branch_i}"
    end
    def assert_operator ins_i , op , left , right , result
      if(ins_i.is_a?(Integer))
        ins = risc(ins_i)
      else
        ins = ins_i
        ins_i = :unknown
      end
      assert_equal Risc::OperatorInstruction , ins.class , "Class at:#{ins_i}"
      assert_equal op , ins.operator
      assert_register :left , left , ins.left , ins_i
      assert_register :right , right , ins.right, ins_i
      assert_register :result , result , ins.result, ins_i
    end
    def assert_zero ins_i , label
      assert_equal Integer , ins_i.class, "assert_zero #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::IsZero , ins.class , "Class at:#{ins_i}"
      assert_label ins.label , label , "Label at:#{ins_i}"
    end
    def assert_not_zero ins_i , label
      assert_equal Integer , ins_i.class, "assert_not_zero #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::IsNotZero , ins.class, "Class at:#{ins_i}"
      assert_label ins.label , label, "Label at:#{ins_i}"
    end
    def assert_syscall ins_i , name
      assert_equal Integer , ins_i.class, "assert_syscall #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::Syscall , ins.class, "Class at:#{ins_i}"
      assert_equal ins.name , name
    end
    def assert_function_call ins_i , name
      assert_equal Integer , ins_i.class, "assert_function_call #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::FunctionCall , ins.class, "Class at:#{ins_i}"
      assert_equal name, ins.method.name , "Method name at #{ins_i}"
    end
    def assert_minus ins_i , label
      assert_equal Integer , ins_i.class, "assert_minus #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::IsMinus , ins.class, "Class at:#{ins_i}"
      assert_label ins.label , label, ins_i
    end
    def assert_data(ins_i , data)
      assert_equal Integer , ins_i.class, "assert_data #{ins_i}"
      ins = risc(ins_i)
      assert_equal Risc::LoadData , ins.class, "Class at:#{ins_i}"
      assert_equal data , ins.constant , "Data at:#{ins_i}"
    end

    def assert_return(at)
      assert_label at , "return_label"
      assert_slot_to_reg at + 1 , :message , 4 , "message.return_address"
      assert_slot_to_reg at + 2 , :message , 6 , :message
      assert_equal Risc::FunctionReturn , risc(at + 3).class
      assert_label at + 4 , "unreachable"
    end
    def assert_allocate
      assert_load 1 , Parfait::Factory , "id_factory_"
      assert_load 2 , Parfait::NilClass , "id_nilclass_"
      assert_slot_to_reg 3 , "id_factory_" , 2 , "id_factory_.next_object"
      assert_operator 4 , :- , "id_nilclass_" , "id_factory_.next_object" , "op_-_"
      assert_not_zero 5 , "cont_label"
      assert_slot_to_reg 6 , "id_factory_" , 3 , "id_factory_.reserve"
      assert_reg_to_slot 7 , "id_factory_.reserve" , "id_factory_" , 2
      assert_load 8 , Parfait::Factory , "id_factory_"
      assert_load 9 , Parfait::CallableMethod , "id_callablemethod"
      assert_slot_to_reg 10 , :message , 1 , "message.next_message"
      assert_reg_to_slot 11 , "id_callablemethod_" , "message.next_message" , 7
      assert_reg_to_slot 12 , "id_factory_" , :message , 2
      assert_load 13 , Risc::Label , "id_label"
      assert_slot_to_reg 14 , :message , 1 , "message.next_message"
      assert_reg_to_slot 15 , "id_label" , "message.next_message" , 4
      assert_slot_to_reg 16 ,:message , 1 , :message
      assert_function_call 17 , :main
      assert_label 18 , "after_main_"
      assert_label 19 , "cont_label"
      assert_slot_to_reg 20 , "id_factory_.next_object" , 1 , "id_factory_.next_object.next_integer"
      assert_reg_to_slot 21 , "id_factory_.next_object.next_integer" , "id_factory_" , 2
    end
  end
end
def Risc.allocate_length
  21
end
# see test in test/slot_machine/macro/test_init.rb
def Risc.init_length
  18 # initial label ignored in above test
end
