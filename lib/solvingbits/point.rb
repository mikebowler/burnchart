# frozen_string_literal: true

module SolvingBits

  class Point
    attr_accessor :x, :y

    def initialize x:, y:
      @x = x
      @y = y
    end

    def == other
      x == other.x && y == other.y
    end

    def to_s
      "Point(x:#{@x},y:#{@y})"
    end
  end
end