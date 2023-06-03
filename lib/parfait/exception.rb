module Parfait
  class Exception < Object
    def initialize
      super
    end

    def to_s
      'Exception'
    end
  end

  class StandardError < Exception
    def initialize
      super
    end

    def to_s
      'StandardError'
    end
  end

  class RuntimeError < StandardError
    def initialize
      super
    end

    def to_s
      'RuntimeError'
    end
  end
end
