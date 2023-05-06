module Ruby
  class Statements < Statement
    attr_reader :statements
    def initialize(statements)
      @statements = []
      statements.each{|st| self << st}
    end

    def empty?
      @statements.empty?
    end
    def single?
      @statements.length == 1
    end
    def first
      @statements.first
    end
    def last
      @statements.last
    end
    def length
      @statements.length
    end
    def shift
      @statements.shift
    end
    def pop
      @statements.pop
    end
    def [](i)
      @statements[i]
    end
    def <<(o)
      raise "Not Statement #{o.class}=#{o.to_s[0..100]}" unless o.is_a?(Statement)
      @statements << o
      self
    end
    def to_sol
      return first.to_sol if( single? )
      brother = sol_brother.new(nil)
      @statements.each do |s|
        brother << s.to_sol
      end
      brother
    end

    def to_s(depth = 0)
      at_depth(depth , @statements.collect{|st| st.to_s(0)}.join("\n"))
    end

  end

  class ScopeStatement < Statements
  end
end
