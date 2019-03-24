require 'spec_helper'
include SolvingBits

RSpec.describe VerticalAxis do
  it "should draw simple ticks" do
    component = VerticalAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, show_label: false },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='16' y1='0' x2='16' y2='200' style='stroke:black;'/>" \
      "<line x1='8' y1='150' x2='16' y2='150' style='stroke:black;'/>" \
      "<line x1='8' y1='100' x2='16' y2='100' style='stroke:black;'/>" \
      "<line x1='1' y1='50' x2='16' y2='50' style='stroke:black;'/>" \
      "<line x1='8' y1='0' x2='16' y2='0' style='stroke:black;'/>"
    )
  end

  it 'should draw simple ticks with labels' do
    component = VerticalAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, show_label: true },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='36' y1='6' x2='36' y2='206' style='stroke:black;'/>" \
      "<line x1='28' y1='156' x2='36' y2='156' style='stroke:black;'/>" \
      "<line x1='28' y1='106' x2='36' y2='106' style='stroke:black;'/>" \
      "<line x1='21' y1='56' x2='36' y2='56' style='stroke:black;'/>" \
      "<text x='20' y='60' style='font: italic 13px sans-serif' text-anchor='end'>30</text>" \
      "<line x1='28' y1='6' x2='36' y2='6' style='stroke:black;'/>"
    )
  end

  it "should draw label" do
    component = VerticalAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, show_label: false },
      values: { lower_bound: 0, upper_bound: 40 },
      label: { visible: true, text: 'Time' }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='29' y1='0' x2='29' y2='200' style='stroke:black;'/>" \
      "<line x1='21' y1='150' x2='29' y2='150' style='stroke:black;'/>" \
      "<line x1='21' y1='100' x2='29' y2='100' style='stroke:black;'/>" \
      "<line x1='14' y1='50' x2='29' y2='50' style='stroke:black;'/>" \
      "<line x1='21' y1='0' x2='29' y2='0' style='stroke:black;'/>" \
      "<text x='13' y='0' style='font: 13px sans-serif' text-anchor='end' transform='rotate(270, 13, 0)'>Time</text>"
    )
  end
end
