# frozen_string_literal: true

require 'spec_helper'

module SolvingBits

  RSpec.describe VerticalSegmentedAxis do
    it 'should allow draw simple text' do
      component = VerticalSegmentedAxis.new(
        segments: { width_px: 100, height_px: 100, font_size_px: 13, keys: [1, 2, 3] }
      )

      canvas = SvgCanvas.new
      size = component.preferred_size
      expect(size).to eq Size.new(height: 300, width: 100)

      component.render Viewport.new(
        left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
      )
      expect(canvas.to_svg(:partial)).to eq(
        "<text x='100' y='150' text-anchor='end' alignment-baseline='middle'>1</text>" \
        "<text x='100' y='150' text-anchor='end' alignment-baseline='middle'>2</text>" \
        "<text x='100' y='150' text-anchor='end' alignment-baseline='middle'>3</text>"
      )
    end
  end
end
