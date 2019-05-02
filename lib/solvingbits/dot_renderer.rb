# frozen_string_literal: true

module SolvingBits
  class DotRenderer
    attr_accessor :data_points

    def render left:, right:, top:, bottom:, canvas:
      @data_points.each do |point|
        canvas.circle cx: point.x, cy: point.y, r: 3
      end
    end
  end
end