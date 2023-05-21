module SlotMachine
  class Raise < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      builder.build do
        exception_return_address = message[:exc_return_address].to_reg
        message << message[:exc_handler]
        add_code Risc.function_return("exception return #{compiler.callable.name}", exception_return_address)
      end
      return compiler
    end
  end
end
