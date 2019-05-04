# frozen_string_literal: true

module SolvingBits
  class SimpleChart
    attr_reader :data_layers

    def initialize
      @data_layers = []
    end

    def left_axis= axis
      @y_axis = axis
    end

    def bottom_axis= axis
      @x_axis = axis
    end

    def preferred_size
      x_size = @x_axis.preferred_size
      y_size = @y_axis.preferred_size

      Size.new height: x_size.height + y_size.height, width: x_size.width + y_size.width
    end

    def to_svg svg_flavour = :full
      size = preferred_size
      canvas = SvgCanvas.new
      render Viewport.new(
        left: 0,
        right: size.width,
        top: 0,
        bottom: size.height,
        canvas: canvas
      )
      canvas.to_svg svg_flavour
    end

    def render viewport
      c_size = preferred_size
      x_size = @x_axis.preferred_size
      y_size = @y_axis.preferred_size

      @y_axis.render Viewport.new(
        left: 0,
        right: y_size.width,
        top: 0,
        bottom: y_size.height,
        canvas: viewport.canvas
      )
      @x_axis.render Viewport.new(
        left: y_size.width,
        right: c_size.width,
        top: y_size.height,
        bottom: c_size.height,
        canvas: viewport.canvas
      )
      data_area = Viewport.new(
        left: y_size.width,
        right: y_size.width + x_size.width,
        top: 0,
        bottom: y_size.height,
        canvas: viewport.canvas
      )
      @data_layers.each do |layer|
        render_layer(data_layer: layer, viewport: data_area)
      end
    end

    def render_layer data_layer:, viewport:
      points = data_layer.data.collect do |point|
        Point.new(
          x: @x_axis.to_coordinate_space(
            value: point.x,
            lower_coordinate: viewport.left,
            upper_coordinate: viewport.right
          ),
          y: @y_axis.to_coordinate_space(
            value: point.y,
            lower_coordinate: viewport.top,
            upper_coordinate: viewport.bottom
          )
        )
      end
      data_layer.renderers.each do |renderer|
        renderer.data_points = points if renderer.respond_to? :data_points
        renderer.render viewport
      end
    end
  end
end
