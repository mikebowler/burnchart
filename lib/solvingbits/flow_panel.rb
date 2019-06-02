# frozen_string_literal: true

module SolvingBits
  class FlowPanel < SvgComponent
    include Configurable

    attr_configurable :gap, defaults_to: 0
    attr_configurable :orientation, only: [:vertical, :horizontal], defaults_to: :horizontal

    def initialize params={}
      initialize_configuration params: params
      @components = []
    end

    def add component
      @components << component
    end

    def vertical?
      orientation() == :vertical
    end

    def horizontal?
      orientation() == :horizontal
    end

    def preferred_size
      width = 0
      height = 0

      @components.each do |c|
        size = c.preferred_size
        if vertical?
          width = size.width if size.width > width
          height += size.height
        else
          width += size.width
          height = size.height if size.height > height
        end
      end
      height += gap() * (@components.size() - 1) if vertical?
      width += gap() * (@components.size() - 1) if horizontal?
      Size.new width: width, height: height
    end

    def render viewport
      current_edge = vertical? ? viewport.top : viewport.left

      @components.each do |c|
        size = c.preferred_size
        new_edge = current_edge + size.height
        if vertical?
          c.render Viewport.new(
            left: viewport.left, right: viewport.left + size.width,
            top: current_edge, bottom: new_edge,
            canvas: viewport.canvas
          )
        else
          c.render Viewport.new(
            left: current_edge, right: new_edge,
            top: viewport.top, bottom: viewport.top + size.height,
            canvas: viewport.canvas
          )
        end
        current_edge = new_edge + gap()
      end
    end
  end
end
