module SlotMachine

  # Branch jump to the Label given
  # Eg used at the end of while or end of if_true branch
  #
  # Risc equivalent is the same really, called Branch there.
  #
  class Jump < Instruction
    attr_reader :label

    def initialize(label)
      @label = label
    end
    def to_risc(compiler)
      compiler.add_code Risc::Branch.new(self , @label.risc_label(compiler))
    end

    def to_s
      "Jump to #{label}"
    end
  end
end
