# frozen_string_literal: true

require 'solvingbits/abstract_segmented_axis'

module SolvingBits
  class VerticalSegmentedAxis < AbstractSegmentedAxis
    def render viewport
      left_pad = 1

      viewport.canvas.line(
        x1: viewport.right,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.bottom,
        style: 'stroke:black;'
      )

      segments_keys.each_with_index do |key, index|
        viewport.canvas.text(
          key.to_s,
          x: viewport.right - left_pad,
          y: viewport.bottom - (segments_height_px() * index) - (segments_height_px() / 2),
          text_anchor: 'end',
          alignment_baseline: 'middle'
        )
      end
    end

    def preferred_size
      Size.new(
        width: segments_width_px(),
        height: segments_keys().length() * segments_height_px()
      )
    end
  end
end
