# frozen_string_literal: true

require 'spec_helper'
include SolvingBits

RSpec.describe HorizontalSegmentedAxis do
  it 'should allow draw simple text' do
    component = HorizontalSegmentedAxis.new(
      segments: { width_px: 100, height_px: 100, font_size_px: 13, keys: [1, 2, 3] }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    expect(size).to eq Size.new(height: 13, width: 300)

    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<text x='50' y='13' text-anchor='middle'>1</text>" \
      "<text x='150' y='13' text-anchor='middle'>2</text>" \
      "<text x='250' y='13' text-anchor='middle'>3</text>"
    )
  end
end
