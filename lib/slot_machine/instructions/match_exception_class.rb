module SlotMachine
  class MatchExceptionClass < Instruction
    def initialize(source, exception_class_to_match, matched_label: nil, not_matched_label: nil)
      super(source)
      @exception_class_to_match = exception_class_to_match
      @matched_label = matched_label
      @not_matched_label = not_matched_label
    end

    def to_risc(compiler)
      exception_object = SlotMachine::Slotted.for(Parfait.object_space, [:current_exception])
      expected_exception_class = Parfait.object_space.get_class_by_name(expected_exception_class_name)
      IsKindOf.new(exception_object, expected_exception_class,
                   true_label: @matched_label, false_label: @not_matched_label).to_risc(compiler)
    end

    def to_s
      "MatchExceptionClass #{expected_exception_class_name}"
    end

    private

    def expected_exception_class_name
      case @exception_class_to_match
      when Symbol
        @exception_class_to_match
      when Sol::ModuleName
        @exception_class_to_match.name
      else
        raise "Not implemented #{@exception_class_to_match}:#{@exception_class_to_match.class}"
      end
    end
  end
end
