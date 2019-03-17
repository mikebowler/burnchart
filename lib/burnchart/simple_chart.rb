module Burnchart

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
      c_size = preferred_size
      x_size = @x_axis.preferred_size
      y_size = @y_axis.preferred_size

      canvas = SvgCanvas.new
      @y_axis.render(
        left: 0,
        right: y_size.width,
        top: 0,
        bottom: y_size.height,
        canvas: canvas
      )
      @x_axis.render(
        left: y_size.width,
        right: c_size.width,
        top: y_size.height,
        bottom: c_size.height,
        canvas: canvas
      )
      @data_layers.each do |layer|
        render_layer(
          data_layer: layer,
          left: y_size.width,
          right: y_size.width + x_size.width,
          top: x_size.height,
          bottom: x_size.height + y_size.height,
          canvas: canvas
        )
      end
      canvas.to_svg svg_flavour
    end

    def render_layer data_layer:, left:, right:, top:, bottom:, canvas:
      points = data_layer.data.collect do |point|
        Point.new(
          x: @x_axis.to_coordinate_space(
            value: point.x,
            lower_coordinate: left,
            upper_coordinate: right
          ),
          y: @y_axis.to_coordinate_space(
            value: point.y,
            lower_coordinate: top,
            upper_coordinate: bottom
          )
        )
      end
      data_layer.renderers.each do |renderer|
        renderer.render canvas: canvas, points: points
      end
    end
  end
end
