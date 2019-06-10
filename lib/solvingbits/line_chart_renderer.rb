# frozen_string_literal: true

module SolvingBits
  class LineChartRenderer < SvgComponent
    include Configurable

    attr_accessor :data_points
    attr_configurable :line_type, only: %w[step straight], defaults_to: 'straight'

    def initialize params = {}
      initialize_configuration params: params
    end

    def render viewport
      # Without at least two points, there's nothing to draw
      return if @data_points.length < 2

      a = @data_points[0]
      1.upto(@data_points.length - 1) do |index|
        b = @data_points[index]
        color = b.metadata[:color] || 'red'
        title = b.metadata[:title]
        if line_type() == 'straight'
          viewport.canvas.line x1: a.x, y1: a.y, x2: b.x, y2: b.y, style: "stroke:#{color}" do
            viewport.canvas.title title unless title.nil?
          end
        elsif line_type() == 'step'
          viewport.canvas.line x1: a.x, y1: a.y, x2: b.x, y2: a.y, style: "stroke:#{color}" do
            viewport.canvas.title title unless title.nil?
          end
          viewport.canvas.line x1: b.x, y1: a.y, x2: b.x, y2: b.y, style: "stroke:#{color}" do
            viewport.canvas.title title unless title.nil?
          end
        else
          raise "Unexpected line type: #{line_type()}"
        end
        a = b
      end
    end
  end
end
