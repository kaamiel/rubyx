module Ruby
  class EnsureStatement < Statement
    attr_reader :body, :ensure_body

    def initialize(body, ensure_body)
      @body = body
      @ensure_body = ensure_body
    end

    def to_sol
      sol_brother.new(@body&.to_sol, @ensure_body&.to_sol)
    end

    def to_s(depth = 0)
      body_s = "#{@body.to_s(1)}\n" if @body
      ensure_body_s = "#{@ensure_body.to_s(1)}\n" if @ensure_body
      at_depth(depth, "begin\n#{body_s}ensure\n#{ensure_body_s}end")
    end
  end
end
