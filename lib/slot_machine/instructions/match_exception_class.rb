module SlotMachine
  class MatchExceptionClass < Instruction
    def initialize(source, exception_classes, next_rescue_body_label)
      super(source)
      @exception_classes = exception_classes
      @next_rescue_body_label = next_rescue_body_label
    end

    def to_risc(compiler)
      # todo
      label = Risc.label(self, "match_exception_class_#{object_id.to_s(16)}")

      compiler.build(to_s) do
        add_code label
      end
    end

    def to_s
      'MatchExceptionClass'
    end
  end
end
