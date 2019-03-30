# frozen_string_literal: true

module SolvingBits
  class LineChartRenderer
    attr_accessor :data_points

    def render left:, right:, top:, bottom:, canvas:
      # Without at least two points, there's nothing to draw
      return if @data_points.length < 2

      a = @data_points[0]
      1.upto(@data_points.length - 1) do |index|
        b = @data_points[index]
        canvas.line x1: a.x, y1: a.y, x2: b.x, y2: b.y, style: 'stroke:red'
        a = b
      end
    end
  end
end
