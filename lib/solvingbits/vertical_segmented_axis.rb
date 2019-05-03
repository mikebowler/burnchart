# frozen_string_literal: true

require 'solvingbits/abstract_segmented_axis'

module SolvingBits
  class VerticalSegmentedAxis < AbstractSegmentedAxis
    def render viewport
      segments_keys.each_with_index do |key, index|
        left_edge = viewport.left + (segments_width_px() * index)
        viewport.canvas.text(
          key.to_s,
          x: viewport.right,
          y: viewport.bottom - (viewport.height / 2),
          text_anchor: 'end',
          alignment_baseline: 'middle'
        )
      end
      viewport.draw_outline
    end

    def preferred_size
      Size.new(
        width: segments_width_px(),
        height: segments_keys().length() * segments_height_px()
      )
    end
  end
end
