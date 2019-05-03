# frozen_string_literal: true

require 'solvingbits/abstract_segmented_axis'

module SolvingBits
  class HorizontalSegmentedAxis < AbstractSegmentedAxis

    def render viewport
      top_pad = 1
      padding_between = 1
      tick_length = 3

      viewport.canvas.line(
        x1: viewport.left,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.top,
        style: 'stroke:black;'
      )


      segments_keys.each_with_index do |key, index|
        left_edge = viewport.left + (segments_width_px() * index)
        viewport.canvas.text(
          key.to_s,
          x: left_edge + (segments_width_px() / 2),
          y: viewport.top + segments_font_size_px + top_pad,
          text_anchor: 'middle',
          alignment_baseline: 'top'
        )
      end
    end

    def preferred_size
      Size.new(
        height: segments_height_px(),
        width: segments_keys().length() * segments_width_px()
      )
    end
  end
end
