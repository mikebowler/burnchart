# frozen_string_literal: true

require 'solvingbits/abstract_linear_axis'

module SolvingBits

  class HorizontalLinearAxis < AbstractLinearAxis

    def render viewport
      viewport.canvas.line(
        x1: viewport.left,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.top,
        style: 'stroke:black;'
      )

      major_tick_bottom_edge = viewport.top + major_ticks_length
      minor_tick_bottom_edge = viewport.top + minor_ticks_length

      ticks.each do |x, is_major_tick, label|
        tick_bottom_edge = (is_major_tick ? major_tick_bottom_edge : minor_tick_bottom_edge)
        viewport.canvas.line(
          x1: x + viewport.left,
          y1: viewport.top,
          x2: x + viewport.left,
          y2: tick_bottom_edge,
          style: 'stroke:black;'
        )
        
        if major_ticks_label_visible() && is_major_tick
          viewport.canvas.text(
            label,
            x: x + viewport.left,
            y: major_tick_bottom_edge + major_ticks_label_font_size_px(),
            style: "font: italic #{major_ticks_label_font_size_px()}px sans-serif",
            text_anchor: 'middle'
          )
        end
      end

      if label_visible()
        viewport.canvas.text(
          label_text(),
          x: viewport.right,
          y: viewport.bottom,
          style: "font: #{label_font_size_px()}px sans-serif",
          text_anchor: 'end'
        )
      end
    end

    def preferred_size
      height = major_ticks_length
      height += major_ticks_label_font_size_px() if major_ticks_label_visible()
      height += label_font_size_px() if label_visible()

      delta = values_upper_bound - values_lower_bound
      Size.new(
        height: height,
        width: (delta * minor_ticks_px_between).to_i
      )
    end

    class BackgroundLineRenderer
      include Configurable
      attr_configurable :color, defaults_to: 'lightgray'
      def initialize axis
        @axis = axis
      end

      def render viewport
        @axis.ticks.each do |x, is_major_tick, _label|
          next unless is_major_tick
          next if x.zero? # Don't draw over the y axis, regardless of settings

          viewport.canvas.line(
            x1: viewport.left + x,
            y1: viewport.top,
            x2: viewport.left + x,
            y2: viewport.bottom,
            style: "stroke: #{color()}"
          )
        end
      end
    end

    def background_line_renderer
      BackgroundLineRenderer.new(self)
    end
  end
end