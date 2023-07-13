module Sol
  class ReturnStatement < Statement

    attr_reader :return_value

    def initialize(value)
      @return_value = value
    end

    def each(&block)
      block.call(self)
      @return_value.each(&block)
    end

    # Since the return is normalized to only allow simple values it is simple.
    # To return form a method in slot_machine instructions we only need to do two things:
    # - store the given return value, this is a SlotMove
    # - activate return sequence (reinstantiate old message and jump to return address)
    def to_slot( compiler )
      if @return_value.is_a?(CallStatement)
        ret = @return_value.to_slot(compiler)
        ret << slot_load(compiler)
      else
        ret = slot_load(compiler)
      end
      ret << SlotMachine::ReturnJump.new(self, compiler.get_return_label)
    end

    def to_s(depth = 0)
      at_depth(depth , "return #{@return_value.to_s}")
    end

    def slot_load(compiler)
      SlotMachine::SlotLoad.new(self, [:message, :caller, :return_value],
                                      @return_value.to_slotted(compiler))
    end
  end
end
