module Ruby
  class RescueStatement < Statement
    attr_reader :body, :rescue_bodies

    def initialize(body, rescue_bodies)
      @body = body
      @rescue_bodies = rescue_bodies
    end

    def to_sol
      sol_brother.new(@body&.to_sol, @rescue_bodies.map(&:to_sol))
    end

    def to_s(depth = 0)
      body_s = @body.to_s(1) if @body
      rescue_bodies_s = @rescue_bodies.map { |rescue_body| rescue_body.to_s(0) }.join("\n")
      at_depth(depth, "begin\n#{body_s}\n#{rescue_bodies_s}\nend")
    end
  end
end
