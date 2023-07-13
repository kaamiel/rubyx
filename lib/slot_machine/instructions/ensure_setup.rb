module SlotMachine
  class EnsureSetup < Instruction
    def initialize(source, marker)
      super(source)
      @marker = marker
      raise "marker: expected Slotted, given #{@marker}" unless @marker.is_a?(Slotted)
    end

    def to_risc(compiler)
      marker = @marker.to_register(compiler, self)
      compiler.build(to_s) do
        space = load_object Parfait.object_space
        space[:ensure_list][:marker] << marker
      end
    end

    def to_s
      "EnsureSetup #{@marker.known_object.value}"
    end
  end
end
