module SlotMachine
  class Raise < Macro
    def initialize(source, index = :arg1)
      super(source)
      @index = index
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      index = @index
      validate = index == :arg1
      if validate
        no_arguments_label = Risc.label(self, "raise_no_args_#{object_id.to_s(16)}")
        type_error_label = SlotMachine::Label.new(source, "raise_type_error_#{object_id.to_s(16)}")
        merge_label = Risc.label(self, "raise_merge_#{object_id.to_s(16)}")

        exception_class = Parfait.object_space.get_class_by_name(:Exception)
        runtime_error_class = Parfait.object_space.get_class_by_name(:RuntimeError)
        type_error_class = Parfait.object_space.get_class_by_name(:TypeError)
      end

      builder.build do
        if validate
          arguments_given = message[:arguments_given].to_reg.reduce_int
          arguments_given.op :|, arguments_given
          if_zero no_arguments_label

          exception_object_class = Slotted.for(:message, [index])
          IsKindOf.new(exception_object_class, exception_class, false_label: type_error_label).to_risc(compiler)

          message[:exc_handler][:return_value] << exception_object_class.to_register(compiler, self)
          branch merge_label

          add_code type_error_label.risc_label(compiler)
          type_error = load_object type_error_class
          message[:exc_handler][:return_value] << type_error # exception class expected
          branch merge_label
        else
          message[:exc_handler][:return_value] << message[index]
        end

        if validate
          add_code no_arguments_label
          runtime_error = load_object runtime_error_class
          message[:exc_handler][:return_value] << runtime_error # raise with no arguments defaults to RuntimeError

          add_code merge_label
        end

        exception_return_address = message[:exc_return_address].to_reg
        message << message[:exc_handler]
        add_code Risc.function_return("exception return #{compiler.callable.name}", exception_return_address)
      end
      return compiler
    end

    def to_s
      "Raise #{@index}"
    end
  end
end
