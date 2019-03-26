require 'solvingbits/abstract_axis'

module SolvingBits
  class VerticalAxis < AbstractAxis

    # We need the top pad to ensure we aren't truncating labels
    # TODO: Be smarter about this. We only need the padding if there is a label right at the
    # top and today we're always putting padding just in case
    def top_pad
      if major_ticks_label_visible()
        major_ticks_label_font_size_px() / 2
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
        if major_ticks_label_visible() && is_major_tick
          canvas.text(
            label,
            x: tick_left_edge - 1,
            y: bottom - y,
            style: "font: italic #{major_ticks_label_font_size_px}px sans-serif",
            text_anchor: 'end',
            alignment_baseline: 'middle'
          )
        end
      end

      if label_visible()
        x_rotation = left + label_font_size_px()
        y_rotation = top

        canvas.text(
          label_text(),
          x: x_rotation,
          y: y_rotation,
          style: "font: #{label_font_size_px()}px sans-serif",
          transform: "rotate(270, #{x_rotation}, #{y_rotation})",
          text_anchor: 'end'
        )
      end

    end

    def preferred_size
      width = major_ticks_length() + 1
      width += label_width(values_upper_bound().to_s) if major_ticks_label_visible()
      width += label_font_size_px() if label_visible()

      Size.new(
        height: (values_upper_bound() * minor_ticks_px_between()).to_i + top_pad,
        width: width
      )
    end
  end
end
