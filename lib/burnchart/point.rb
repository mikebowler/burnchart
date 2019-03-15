module Burnchart

  class Point
    attr_accessor :x, :y

    def initialize x:, y:
      @x = x
      @y = y
    end

    def == other
      self.x == other.x && self.y == other.y
    end

    def to_s
      "Point(x:#{@x},y:#{@y})"
    end
  end
end