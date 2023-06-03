module Sol
  module Builtin
    def self.boot_methods(options)
      return if options[:boot_methods] == false
      load_builtin( "Integer.plus" )
    end

    def self.load_builtin(loads)
      return "class Space;def main(arg);return 0; end; end" if(loads == "Space.main")
      raise "no preload #{loads}" unless builtin[loads]
      clazz , meth = loads.split(".")
      "class #{clazz} #{derive(clazz)}; #{builtin[loads]};end;"
    end

    def self.derive(clazz) #must get derived classes rigth, so no mismatch
      case clazz
      when "Integer"
        "< Data4"
      when "Word"
        " < Data8"
      else
        ""
      end
    end
    def self.builtin
      {
        "Object.get" => "def get_internal_word(at); X.get_internal_word;end",
        "Object.missing" => "def method_missing(at); X.method_missing(:r1);end",
        "Object.raise" => "def raise(at); X.raise(:arg1);end",
        "Object.exit" => "def exit; X.exit;end",
        "Integer.div4" => "def div4; X.div4;end",
        "Integer.div10" => "def div10; X.div10;end",
        "Integer.gt" => "def >; X.comparison(:>);end",
        "Integer.lt" => "def <; X.comparison(:<);end",
        "Integer.ge" => "def >=; X.comparison(:>=);end",
        "Integer.le" => "def <=; X.comparison(:<=);end",
        "Integer.plus" => "def +; X.int_operator(:+);end",
        "Integer.minus" => "def -; X.int_operator(:-);end",
        "Integer.mul" => "def *; X.int_operator(:*);end",
        "Integer.and" => "def &; X.int_operator(:&);end",
        "Integer.or" => "def |; X.int_operator(:|);end",
        "Integer.ls" => "def <<; X.int_operator(:<<);end",
        "Integer.rs" => "def >>; X.int_operator(:>>);end",
        "Word.put" => "def putstring(at); X.putstring;end",
        "Word.set" => "def set_internal_word(at, val); X.set_internal_word;end",
        "Word.get" => "def get_internal_word(at); X.get_internal_word;end",
        "Word.set_byte" => "def set_internal_byte(at, val); X.set_internal_byte;end",
        "Word.get_byte" => "def get_internal_byte(at); X.get_internal_byte;end",
      }
    end
    def self.builtin_code
      keys = builtin.keys
      keys.pop
      keys.collect { |loads| load_builtin(loads)}.join
    end
  end
end
