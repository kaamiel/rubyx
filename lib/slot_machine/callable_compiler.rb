module SlotMachine

  # CallableCompiler is used to generate slot instructions. It is an abstact base
  # class shared by BlockCompiler and MethodCompiler

  # - slot_instructions: The sequence of slot level instructions that was compiled to
  #                 Instructions derive from class Instruction and form a linked list

  # Since we have many different compilers, and they are kept in lists, the
  # Util CompilerList encapsulates the list behaviour
  #
  class CallableCompiler
    include Util::CompilerList

    def initialize( callable )
      @callable = callable
      @constants = []
      @exception_return_labels = []
      @slot_instructions = Label.new(source_name, source_name)
      @current = start = @slot_instructions
      add_code Label.new( source_name, "return_label")
      add_code SlotMachine::ReturnSequence.new(source_name)
      add_code Label.new( source_name, "unreachable")
      @current = start
    end
    attr_reader :slot_instructions , :constants , :callable , :current

    # find the return_label, every method should have exactly one (see constructor)
    # used during return sequence code generation
    def return_label
      @slot_instructions.each do |ins|
        next unless ins.is_a?(Label)
        return ins if ins.name == "return_label"
      end
    end

    # add a constant (which get created during compilation and need to be linked)
    def add_constant(const)
      raise "Must be Parfait #{const}" unless const.is_a?(Parfait::Object)
      @constants << const
    end

    # translate to Risc, ie a Risc level CallableCompiler
    # abstract functon that needs to be implemented by Method/BlockCompiler
    def to_risc
      raise "abstract in #{self.class}"
    end

    # add a risc instruction after the current (insertion point)
    # the added instruction will become the new insertion point
    def add_code( instruction )
      raise "Not an instruction:#{instruction.to_s}:#{instruction.class.name}" unless  instruction.is_a?(SlotMachine::Instruction)
      new_current = instruction.last #after insertion this point is lost
      @current.insert(instruction) #insert after current
      @current = new_current
      self
    end

    def get_exception_return_label
      @exception_return_labels.last
    end

    def add_exception_return_label(label)
      @exception_return_labels << label
    end

    def remove_exception_return_label
      raise 'no exception return labels' unless @exception_return_labels.pop
    end

    # return the frame type, ie the blocks self_type
    def receiver_type
      @callable.self_type
    end

    private

    # convert al instruction to risc
    # method is called by Method/BlockCompiler from to_risc
    def instructions_to_risc(risc_compiler)
      instruction = slot_instructions.next
      while( instruction )
        raise "whats this a #{instruction}" unless instruction.is_a?(SlotMachine::Instruction)
        #puts "adding slot #{instruction.to_s}:#{instruction.next.to_s}"
        instruction.to_risc( risc_compiler )
        #puts "adding risc #{risc.to_s}:#{risc.next.to_s}"
        instruction = instruction.next
      end
    end

  end
end
