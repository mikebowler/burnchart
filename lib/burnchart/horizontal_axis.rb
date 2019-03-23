
module Burnchart

  class HorizontalAxis < AxisSupport

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
        
        if major_ticks_show_label() && is_major_tick
          canvas.text(
            label,
            x: x + left,
            y: major_tick_bottom_edge + font_size_px,
            style: "font: italic #{font_size_px}px sans-serif",
            text_anchor: 'middle'
          )
        end
      end
    end

    def preferred_size
      height = major_ticks_length
      if major_ticks_show_label()
        height += font_size_px
      end

      delta = values_upper_bound - values_lower_bound
      Size.new(
        height: height,
        width: (delta * px_between_ticks).to_i
      )
    end

  end
end