module SlotMachine
  class SlottedObject < Slotted

    attr_reader :known_object

    def initialize( object , slots)
      super(slots)
      @known_object = object
      raise "Not known #{slots}" unless object
    end

    def known_name
      known_object.class.short_name
    end

    # load the slots into a register
    # the code is added to compiler
    # the register returned
    def to_register(compiler, source)
      type = known_object.get_type
      raise "not sym for #{known_object}" if type.is_a?(String)
      last = Risc.load_constant(source, known_object)
      compiler.add_code last
      if slots_length > 1
        last = Risc.slot_to_reg( source , last.register ,slots.name)
        compiler.add_code(last)
      end
      if slots_length > 2
        last = Risc.slot_to_reg( source , last.register , slots.next_slot.name )
        compiler.add_code(last)
      end
      if slots_length > 3
        raise "3 slots only for type #{slots}" unless slots.next_slot.next_slot.name == :type
        last = Risc.slot_to_reg( source , last.register , slots.next_slot.name )
        compiler.add_code(last)
      end
      return last.register
    end

    # Note: this is the left hand case, the right hand being to_register
    #       They are very similar (apart from the final reg_to_slot here) and should
    #       most likely be united
    def reduce_and_load(const_reg , compiler , original_source )
      raise 'only cache or space' unless known_object.is_a?(Parfait::CacheEntry) || known_object.is_a?(Parfait::Space)
      load = Risc.load_constant(original_source, known_object )
      left = load.register
      compiler.add_code load
      compiler.add_code Risc.reg_to_slot(original_source, const_reg , left, slots.name)
    end
  end
end
