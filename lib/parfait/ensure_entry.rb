module Parfait
  class EnsureEntry < Object
    attr_reader :prev_entry, :next_entry, :marker

    def initialize
      super
    end

    def to_s
      'EnsureEntry'
    end

    def _set_next_entry(nekst)
      @next_entry = nekst
    end

    def _set_prev_entry(prev)
      @prev_entry = prev
    end
  end
end
