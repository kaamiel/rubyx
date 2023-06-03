module SlotMachine
  class Raise < Macro
    def initialize(source, index)
      super(source)
      @index = index
    end

    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      index = @index
      builder.build do
        message[:exc_handler][:return_value] << message[index]
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
