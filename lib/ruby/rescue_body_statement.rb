module Ruby
  class RescueBodyStatement < Statement
    def initialize(exception_classes, assignment, body)
      @exception_classes = exception_classes
      @assignment = assignment
      @body = body
    end

    def to_sol
      sol_brother.new(@exception_classes.map(&:to_sol), @assignment&.to_sol, @body&.to_sol)
    end

    def to_s(depth = 0)
      exception_classes_s = @exception_classes.join(', ')
      assignment_s = " => #{@assignment.name}" if @assignment
      body_s = @body.to_s(1) if @body
      at_depth(depth, "rescue #{exception_classes_s}#{assignment_s}\n#{body_s}")
    end
  end
end
