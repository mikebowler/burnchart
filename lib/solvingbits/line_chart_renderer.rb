module SolvingBits
  class LineChartRenderer
    def render canvas:, points:
      # Without at least two points, there's nothing to draw
      return if points.length < 2

      a = points[0]
      1.upto(points.length - 1) do |index|
        b = points[index]
        canvas.line x1: a.x, y1: a.y, x2: b.x, y2: b.y, style: 'stroke:red'
        a = b
      end
    end
  end
end
