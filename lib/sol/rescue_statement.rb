module Sol
  class RescueStatement < Statement
    attr_reader :body, :rescue_bodies, :else_body

    def initialize(body, rescue_bodies, else_body)
      @body = body
      @rescue_bodies = rescue_bodies
      @else_body = else_body
    end

    def to_slot(compiler)
      after_label = SlotMachine::Label.new(self, "after_handle_exception_#{object_id.to_s(16)}")
      return after_label unless @body || @else_body
      return @else_body.to_slot(compiler) unless @body

      exception_return_label = SlotMachine::Label.new(self, "handle_exception_#{object_id.to_s(16)}_rescue_1")
      instructions = rescued_body(compiler, exception_return_label)
      instructions << @else_body&.to_slot(compiler)
      instructions << SlotMachine::Jump.new(after_label)
      instructions << rescues(compiler, exception_return_label, after_label)
      instructions << after_label
    end

    def each(&block)
      @body&.each(&block)
      @rescue_bodies.each { |rescue_body| rescue_body.each(&block) }
      @else_body&.each(&block)
    end

    def to_s(depth = 0)
      body_s = @body.to_s(1) if @body
      rescue_bodies_s = @rescue_bodies.map { |rescue_body| rescue_body.to_s(0) }.join("\n")
      else_body_s = "else\n#{@else_body.to_s(1)}\n" if @else_body
      at_depth(depth, "begin\n#{body_s}\n#{rescue_bodies_s}\n#{else_body_s}end")
    end

    private

    def rescued_body(compiler, exception_return_label)
      compiler.add_exception_return_label(exception_return_label)
      instructions = @body.to_slot(compiler)
      compiler.remove_exception_return_label

      instructions
    end

    def rescues(compiler, rescue_body_label, after_label)
      instructions = rescue_body_label
      @rescue_bodies.each_with_index do |rescue_body, index|
        rescue_body_label = SlotMachine::Label.new(self, "handle_exception_#{object_id.to_s(16)}_rescue_#{index + 2}")
        matched_label = SlotMachine::Label.new(self, "handle_exception_#{object_id.to_s(16)}_rescue_#{index + 1}_matched")

        instructions << match_exception_classes(rescue_body.exception_classes, matched_label, rescue_body_label)
        instructions << matched_label if rescue_body.exception_classes.length > 1
        instructions << restore_previous_exception
        instructions << rescue_body.to_slot(compiler)
        instructions << SlotMachine::Jump.new(after_label)
        instructions << rescue_body_label
      end
      instructions << exception_class_not_matched(compiler)
    end

    def match_exception_classes(exception_classes_to_match, matched_label, not_matched_label)
      instructions = exception_classes_to_match[..-2].map do |exception_class_to_match|
        SlotMachine::MatchExceptionClass.new(self, exception_class_to_match, matched_label: matched_label)
      end
      last_exception_class_to_match = exception_classes_to_match[-1] || :StandardError # rescue with no arguments defaults to StandardError
      instructions << SlotMachine::MatchExceptionClass.new(self, last_exception_class_to_match,
                                                           not_matched_label: not_matched_label)
      instructions.reduce(:<<)
    end

    def restore_previous_exception
      SlotMachine::SlotLoad.new(self, [Parfait.object_space, :current_exception],
                                      [Parfait.object_space, :current_exception, :cause])
    end

    def exception_class_not_matched(compiler)
      previous_exception_return_label = compiler.get_exception_return_label
      if previous_exception_return_label
        SlotMachine::Jump.new(previous_exception_return_label)
      else
        SlotMachine::Raise.new(self)
      end
    end
  end
end
