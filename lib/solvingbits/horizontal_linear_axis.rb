# frozen_string_literal: true

require 'solvingbits/abstract_linear_axis'

module SolvingBits

  class HorizontalLinearAxis < AbstractLinearAxis

    def render left:, right:, top:, bottom:, canvas:
      canvas.line x1: left, y1: top, x2: right, y2: top, style: 'stroke:black;'

      major_tick_bottom_edge = top + major_ticks_length
      minor_tick_bottom_edge = top + minor_ticks_length

      ticks.each do |x, is_major_tick, label|
        tick_bottom_edge = (is_major_tick ? major_tick_bottom_edge : minor_tick_bottom_edge)
        canvas.line(
          x1: x + left,
          y1: top,
          x2: x + left,
          y2: tick_bottom_edge,
          style: 'stroke:black;'
        )
        
        if major_ticks_label_visible() && is_major_tick
          canvas.text(
            label,
            x: x + left,
            y: major_tick_bottom_edge + major_ticks_label_font_size_px(),
            style: "font: italic #{major_ticks_label_font_size_px()}px sans-serif",
            text_anchor: 'middle'
          )
        end
      end

      if label_visible()
        canvas.text(
          label_text(),
          x: right,
          y: bottom,
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

      def render left:, right:, top:, bottom:, canvas:
        @axis.ticks.each do |x, is_major_tick, _label|
          next unless is_major_tick
          next if x.zero? # Don't draw over the y axis, regardless of settings

          canvas.line(
            x1: left + x,
            y1: top, 
            x2: left + x,
            y2: bottom,
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