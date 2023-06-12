module Ruby
  class MethodStatement < Statement
    attr_reader :name, :args , :body

    def initialize( name , args , body)
      @name , @args , @body = name , args , body
      raise "no bod" unless @body
    end

    # At the moment normalizing means creating implicit returns for some cases
    # see replace_return for details.
    def normalized_body(statement)
      return replace_return(statement) unless statement.is_a?(Statements)
      body = Statements.new(statement.statements.dup)
      body << replace_return(body.pop)
    end

    def to_sol
      body = normalized_body(@body)
      Sol::MethodExpression.new( @name , @args.dup , body.to_sol)
    end

    def replace_return(statement)
      case statement
      when SendStatement , YieldStatement, Variable , Constant
         return ReturnStatement.new( statement )
      when IvarAssignment
        ret = ReturnStatement.new( InstanceVariable.new(statement.name) )
        return Statements.new([statement , ret])
      when LocalAssignment
        ret = ReturnStatement.new( LocalVariable.new(statement.name) )
        return Statements.new([statement , ret])
      when ReturnStatement , IfStatement , WhileStatement ,RubyBlockStatement
        return statement
      when ScopeStatement
        return normalized_body(statement)
      when RescueStatement
        return ReturnStatement.new(NilConstant.new) unless statement.body

        body = normalized_body(statement.body)
        rescue_bodies = statement.rescue_bodies.map do |rescue_body|
          RescueBodyStatement.new(rescue_body.exception_classes, rescue_body.assignment,
                                  normalized_body(rescue_body.body))
        end
        return RescueStatement.new(body, rescue_bodies)
      else
        raise "Not implemented implicit return #{statement.class}"
      end
    end

    def to_s(depth = 0)
      arg_str = @args.collect{|a| a.to_s}.join(', ')
      at_depth(depth , "def #{name}(#{arg_str})\n #{@body.to_s(1)}\nend")
    end

  end
end
