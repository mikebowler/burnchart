# frozen_string_literal: true

require 'spec_helper'

module SolvingBits

  RSpec.describe SegmentedAxis do
    context 'horizontal' do
      it 'should allow draw simple text' do
        component = SegmentedAxis.new(
          orientation: :horizontal,
          segments: { width_px: 100, height_px: 100, font_size_px: 13, keys: [1, 2, 3] }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        expect(size).to eq Size.new(height: 100, width: 300)

        component.render Viewport.new(
          left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        )
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='0' y1='0' x2='300' y2='0' style='stroke:black;'/>" \
          "<text x='50' y='14' text-anchor='middle' alignment-baseline='top'>1</text>" \
          "<text x='150' y='14' text-anchor='middle' alignment-baseline='top'>2</text>" \
          "<text x='250' y='14' text-anchor='middle' alignment-baseline='top'>3</text>"
        )
      end
    end

    context 'vertical' do 
      it 'should allow draw simple text' do
        component = SegmentedAxis.new(
          orientation: :vertical,
          segments: { width_px: 100, height_px: 100, font_size_px: 13, keys: [1, 2, 3] }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        expect(size).to eq Size.new(height: 300, width: 100)

        component.render Viewport.new(
          left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        )
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='100' y1='0' x2='100' y2='300' style='stroke:black;'/>" \
          "<text x='99' y='250' text-anchor='end' alignment-baseline='middle'>1</text>" \
          "<text x='99' y='150' text-anchor='end' alignment-baseline='middle'>2</text>" \
          "<text x='99' y='50' text-anchor='end' alignment-baseline='middle'>3</text>"
        )
      end
    end

  end
end
