module SlotMachine
  class IsKindOf < Instruction
    def initialize(object_class, klass, true_label: nil, false_label: nil)
      @object_class = object_class
      @klass = klass
      @true_label = true_label
      @false_label = false_label
      unless @object_class.is_a?(Slotted) || @object_class.is_a?(Risc::RegisterValue)
        raise "object_class: expected Slotted or RegisterValue, given #{@object_class}"
      end
      raise "klass: expected Parfait::Class, given #{@klass}" unless @klass.is_a?(Parfait::Class)
      raise 'at least one label required' unless @true_label || @false_label
    end

    def to_risc(compiler)
      object_class = @object_class
      if object_class.is_a?(Slotted)
        object_class = object_class.to_register(compiler, self).set_compiler(compiler)[:type][:object_class].to_reg
      end
      object_class = object_class.known_type(:Class)
      klass = @klass

      while_start_label = Risc.label(self, "#{@object_class}_is_a?_#{@klass.name}_#{object_id.to_s(16)}")
      true_label = @true_label&.risc_label(compiler)
      false_label = @false_label&.risc_label(compiler)
      while_exit_label = Risc.label(self, "exit_#{@object_class}_is_a?_#{@klass.name}_#{object_id.to_s(16)}") unless true_label && false_label

      compiler.build(to_s) do
        add_code while_start_label

        nil_object = load_object Parfait.object_space.nil_object
        nil_object.op :-, object_class
        if_zero(false_label || while_exit_label)

        klass = load_object klass
        klass.op :-, object_class
        if_zero(true_label || while_exit_label)

        super_class = object_class[:super_class].to_reg
        object_class << super_class

        branch  while_start_label

        add_code while_exit_label if while_exit_label
      end
    end

    def to_s
      "IsKindOf #{@object_class}.is_a? #{@klass.name}"
    end
  end
end
