# frozen_string_literal: true

module SolvingBits
  class FlowPanel < SvgComponent
    def initialize
      @components = []
    end

    def add component
      @components << component
    end

    def preferred_size
      width = 0
      height = 0

      @components.each do |c|
        size = c.preferred_size
        width = size.width if size.width > width
        height = size.height if size.height > height
      end
      Size.new width: width, height: height
    end

    def render viewport
      current_top = viewport.top

      @components.each do |c|
        size = c.preferred_size
        new_top = current_top + size.height
        c.render Viewport.new(
          left: viewport.left, right: viewport.left + size.width,
          top: current_top, bottom: new_top,
          canvas: viewport.canvas
        )
        current_top = new_top
      end
    end
  end
end