require 'spec_helper'
include Burnchart

RSpec.describe HorizontalAxis do
  it "should draw simple ticks" do 
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        minor_tick_length: 8,
        major_ticks_every: 30,
        major_tick_length: 15,
        display_value_for_major_ticks: false,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 40,
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg :partial).to eq(
      "<line x1='0' y1='0' x2='200' y2='0' style='stroke:black;'/>" +
      "<line x1='50' y1='0' x2='50' y2='8' style='stroke:black;'/>" +
      "<line x1='100' y1='0' x2='100' y2='8' style='stroke:black;'/>" +
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke:black;'/>" +
      "<line x1='200' y1='0' x2='200' y2='8' style='stroke:black;'/>"
    )
  end

  it "should draw simple ticks with labels" do 
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        minor_tick_length: 8,
        major_ticks_every: 30,
        major_tick_length: 15,
        display_value_for_major_ticks: true,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 40,
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    File.open 'horizontal_axis.svg', 'w' do |file|
      file.puts canvas.to_svg
    end
    canvas.dump_svg_for_test
    expect(canvas.to_svg :partial).to eq(
      "<line x1='0' y1='0' x2='200' y2='0' style='stroke:black;'/>" +
      "<line x1='50' y1='0' x2='50' y2='8' style='stroke:black;'/>" +
      "<line x1='100' y1='0' x2='100' y2='8' style='stroke:black;'/>" +
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke:black;'/>" +
      "<text x='140' y='28' style='font: italic 13px sans-serif'>30</text>" +
      "<line x1='200' y1='0' x2='200' y2='8' style='stroke:black;'/>"
    )
  end

end