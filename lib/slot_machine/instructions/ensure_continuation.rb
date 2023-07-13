module SlotMachine
  class EnsureContinuation < Instruction
    def initialize(source, standard_label, return_label, exception_return_label)
      super(source)
      @standard_label = standard_label
      @return_label = return_label
      @exception_return_label = exception_return_label
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      integer_1 = builder.register(:integer_1)

      standard_label = @standard_label.risc_label(compiler)
      return_label = @return_label.risc_label(compiler)
      exception_return_label = @exception_return_label&.risc_label(compiler)

      builder.build do
        space = load_object Parfait.object_space
        marker = space[:ensure_list][:marker].to_reg.reduce_int

        marker.op :|, marker
        if_zero standard_label

        load_object(1, integer_1)
        marker.op :-, integer_1
        if_zero return_label

        branch exception_return_label if exception_return_label
      end
      Raise.new(source).to_risc(compiler) unless exception_return_label
    end

    def to_s
      'EnsureContinuation'
    end
  end
end
