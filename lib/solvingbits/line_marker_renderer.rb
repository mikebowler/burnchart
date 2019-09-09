# frozen_string_literal: true

module SolvingBits
  class LineMarkerRenderer < SvgComponent
    include Configurable

    attr_accessor :data_points
    attr_configurable :value

    def initialize params = {}
      initialize_configuration params: params
    end

    def render viewport
      x = viewport.horizontal_axis.to_coordinate_space(
        value: value(), lower_coordinate: viewport.left
      )
      viewport.canvas.line(
        x1: x, y1: viewport.top, x2: x, y2: viewport.bottom, style: 'stroke:red'
      )
    end
  end
end
