require 'spec_helper'
include SolvingBits

RSpec.describe Configurable do
  it 'draw simple line' do
    canvas = SvgCanvas.new
    LineChartRenderer.new.render( 
      canvas: canvas, 
      points: [
        Point.new(x: 4, y: 5),
        Point.new(x: 6, y: 7)
      ]
    )

    expect(canvas.to_svg :partial).to eq(
      "<line x1='4' y1='5' x2='6' y2='7' style='stroke:red'/>"
    )
  end
end