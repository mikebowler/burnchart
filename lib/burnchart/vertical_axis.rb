module Burnchart

  class VerticalAxis < AxisSupport

    # We need the top pad to ensure we aren't truncating labels
    # TODO: Be smarter about this. We only need the padding if there is a label right at the
    # top and today we're always putting padding just in case
    def top_pad
      if display_value_for_major_ticks()
        font_size_px / 2
      else
        0
      end
    end

    def render left:, right:, top:, bottom:, canvas:
      top += top_pad
      canvas.line x1: right, y1: top, x2: right, y2: bottom, style: 'stroke:black;'

      major_tick_left_edge = right - major_ticks_length
      minor_tick_left_edge = right - minor_ticks_length

      ticks.each do |y, is_major_tick, label|
        tick_left_edge = (is_major_tick ? major_tick_left_edge : minor_tick_left_edge)
        canvas.line(
          x1: tick_left_edge,
          y1: bottom - y,
          x2: right,
          y2: bottom - y,
          style: 'stroke:black;'
        )
        if display_value_for_major_ticks && is_major_tick
          canvas.text(
            label,
            x: tick_left_edge - 1,
            y: bottom - y + (font_size_px / 3),
            style: "font: italic #{font_size_px}px sans-serif",
            text_anchor: 'end'
          )
        end
      end
    end

    def preferred_size
      width = major_ticks_length + 1
      if display_value_for_major_ticks
        width += label_width(values_upper_bound.to_s)
      end

      Size.new(
        height: (values_upper_bound * px_between_ticks).to_i + top_pad,
        width: width
      )
    end
  end
end
