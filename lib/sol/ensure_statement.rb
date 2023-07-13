module Sol
  class EnsureStatement < Statement
    def initialize(body, ensure_body)
      @body = body
      @ensure_body = ensure_body
    end

    def to_slot(compiler)
      return ensure_merge_label unless @body || @ensure_body
      return @body.to_slot(compiler) unless @ensure_body
      return @ensure_body.to_slot(compiler) unless @body

      instructions = rescued_body(compiler)
      instructions << push_ensure_entry
      instructions << SlotMachine::Jump.new(ensure_merge_label)

      instructions << ensure_exception_return_label
      instructions << push_ensure_entry(:exception)
      instructions << SlotMachine::Jump.new(ensure_merge_label)

      instructions << ensure_return_label
      instructions << push_ensure_entry(:return)

      instructions << ensure_merge_label
      instructions << @ensure_body.to_slot(compiler)

      instructions << pop_ensure_entry << ensure_continuation(compiler)
      instructions << ensure_after_label
    end

    def each(&block)
      @body&.each(&block)
      @ensure_body&.each(&block)
    end

    def to_s(depth = 0)
      body_s = "#{@body.to_s(1)}\n" if @body
      ensure_body_s = "#{@ensure_body.to_s(1)}\n" if @ensure_body
      at_depth(depth, "begin\n#{body_s}ensure\n#{ensure_body_s}end")
    end

    private

    def ensure_exception_return_label
      @ensure_exception_return_label ||= SlotMachine::Label.new(self, "ensure_rescue_#{object_id.to_s(16)}")
    end

    def ensure_return_label
      @ensure_return_label ||= SlotMachine::Label.new(self, "ensure_return_#{object_id.to_s(16)}")
    end

    def ensure_merge_label
      @ensure_merge_label ||= SlotMachine::Label.new(self, "ensure_#{object_id.to_s(16)}")
    end

    def ensure_after_label
      @ensure_after_label ||= SlotMachine::Label.new(self, "after_ensure_#{object_id.to_s(16)}")
    end

    def rescued_body(compiler)
      compiler.add_exception_return_label(ensure_exception_return_label)
      compiler.add_return_label(ensure_return_label)
      instructions = @body.to_slot(compiler)
      compiler.remove_return_label
      compiler.remove_exception_return_label

      instructions
    end

    def push_ensure_entry(kind = nil)
      current_entry = [Parfait.object_space, :ensure_list]
      marker = case kind
               when :return
                 1
               when :exception
                 2
               else # standard
                 0
               end
      marker = SlotMachine::Slotted.for(SlotMachine::IntegerConstant.new(marker))

      SlotMachine::EnsureSetup.new(self, marker) <<
        SlotMachine::SlotLoad.new(self, current_entry, [*current_entry, :next_entry])
    end

    def pop_ensure_entry
      SlotMachine::SlotLoad.new(self, [Parfait.object_space, :ensure_list],
                                      [Parfait.object_space, :ensure_list, :prev_entry])
    end

    def ensure_continuation(compiler)
      SlotMachine::EnsureContinuation.new(self, ensure_after_label, compiler.get_return_label,
                                                compiler.get_exception_return_label)
    end
  end
end
