# frozen_string_literal: true

module SolvingBits
  class Viewport
    attr_reader :left, :right, :top, :bottom, :canvas, :vertical_axis

    def initialize left:, right:, top:, bottom:, canvas:, vertical_axis: nil
      @left = left
      @right = right
      @top = top
      @bottom = bottom
      @canvas = canvas
      @vertical_axis = vertical_axis
    end

    def width
      @right - @left
    end

    def height
      @bottom - @top
    end

    # Convenience to draw a box around the drawable area.
    def draw_outline color: 'red'
      @canvas.rect(
        x: @left,
        y: @top,
        width: width,
        height: height,
        style: "stroke: #{color}; fill: none"
      )
    end

  end
end
