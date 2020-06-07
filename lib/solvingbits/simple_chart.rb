# frozen_string_literal: true

module SolvingBits
  class SimpleChart < SvgComponent
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

    def render viewport
      c_size = preferred_size
      x_size = @x_axis.preferred_size
      y_size = @y_axis.preferred_size

      @y_axis.render Viewport.new(
        left: viewport.left,
        right: viewport.left + y_size.width,
        top: viewport.top,
        bottom: viewport.top + y_size.height,
        canvas: viewport.canvas
      )
      @x_axis.render Viewport.new(
        left: viewport.left + y_size.width,
        right: viewport.left + c_size.width,
        top: viewport.top + y_size.height,
        bottom: viewport.top + c_size.height,
        canvas: viewport.canvas
      )
      data_area = Viewport.new(
        left: viewport.left + y_size.width,
        right: viewport.left + y_size.width + x_size.width,
        top: viewport.top + @y_axis.top_pad,
        bottom: viewport.top + y_size.height,
        canvas: viewport.canvas,
        vertical_axis: @y_axis,
        horizontal_axis: @x_axis
      )
      @data_layers.each do |layer|
        render_layer data_layer: layer, viewport: data_area
      end
    end

    def render_layer data_layer:, viewport:
      points = data_layer.data.collect do |point|
        puts point if @debug
        new_point = Point.new(
          x: @x_axis.to_coordinate_space(
            value: point.x,
            lower_coordinate: viewport.left
          ),
          y: @y_axis.to_coordinate_space(
            value: point.y,
            lower_coordinate: viewport.top
          )
        ).tap { |p| p.metadata.merge! point.metadata }
        new_point
      end
      data_layer.renderers.each do |renderer|
        renderer.data_points = points if renderer.respond_to? :data_points
        renderer.render viewport
      end
    end
  end
end
