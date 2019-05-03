# frozen_string_literal: true

module SolvingBits
  class Viewport
    attr_reader :left, :right, :top, :bottom, :canvas

    def initialize left:, right:, top:, bottom:, canvas:
      @left = left
      @right = right
      @top = top
      @bottom = bottom
      @canvas = canvas
    end

    def width
      @right - @left
    end

    def height
      @bottom - @top
    end
  end
end