module Ruby
  class RescueStatement < Statement
    attr_reader :body, :rescue_bodies, :else_body

    def initialize(body, rescue_bodies, else_body)
      @body = body
      @rescue_bodies = rescue_bodies
      @else_body = else_body
    end

    def to_sol
      sol_brother.new(@body&.to_sol, @rescue_bodies.map(&:to_sol), @else_body&.to_sol)
    end

    def to_s(depth = 0)
      body_s = @body.to_s(1) if @body
      rescue_bodies_s = @rescue_bodies.map { |rescue_body| rescue_body.to_s(0) }.join("\n")
      else_body_s = "else\n#{@else_body.to_s(1)}\n" if @else_body
      at_depth(depth, "begin\n#{body_s}\n#{rescue_bodies_s}\n#{else_body_s}end")
    end
  end
end
