module Parfait
  class Exception < Object
    attr_reader :cause, :next_exception

    def initialize
      super
    end

    def self.type_length
      3
    end

    def to_s
      'Exception'
    end

    def _set_next_exception(nekst)
      @next_exception = nekst
    end
  end

  class StandardError < Exception
    def to_s
      'StandardError'
    end
  end

  class RuntimeError < StandardError
    def to_s
      'RuntimeError'
    end
  end

  class TypeError < StandardError
    def to_s
      'TypeError'
    end
  end
end
