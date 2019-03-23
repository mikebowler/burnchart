module SolvingBits
  class DotChartRenderer
    def render canvas:, points:
      points.each do |point|
        canvas.circle cx: point.x, cy: point.y, r: 3
      end
    end
  end
end
