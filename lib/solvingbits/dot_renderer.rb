# frozen_string_literal: true

module SolvingBits
  class DotRenderer < SvgComponent
    include Configurable

    attr_accessor :data_points
    attr_configurable :radius, defaults_to: 3

    def initialize params = {}
      initialize_configuration params: params
    end

    def render viewport
      @data_points.each do |point|
        color = point.metadata[:color] || 'red'
        title = point.metadata[:title]

        viewport.canvas.circle cx: point.x, cy: point.y, r: radius, fill: color do
          viewport.canvas.title title unless title.nil?
        end
      end
    end
  end
end
