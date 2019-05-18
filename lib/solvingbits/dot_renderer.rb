# frozen_string_literal: true

module SolvingBits
  class DotRenderer < SvgComponent
    attr_accessor :data_points

    def render viewport
      @data_points.each do |point|
        viewport.canvas.circle cx: point.x, cy: point.y, r: 3
      end
    end
  end
end
