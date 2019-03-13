require 'spec_helper'
include Burnchart

RSpec.describe VerticalAxis do
  # it "should default to basic size" do
  #   expect(VerticalAxis.new.preferred_size).to eql Size.new(height:500, width:8)
  # end

  it "should draw simple ticks" do 
    component = VerticalAxis.new( 
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
      "<line x1='16' y1='0' x2='16' y2='200' style='stroke:black;'/>" +
      "<line x1='8' y1='150' x2='16' y2='150' style='stroke:black;'/>" +
      "<line x1='8' y1='100' x2='16' y2='100' style='stroke:black;'/>" +
      "<line x1='1' y1='50' x2='16' y2='50' style='stroke:black;'/>" +
      "<line x1='8' y1='0' x2='16' y2='0' style='stroke:black;'/>"    )
  end

  it "should draw simple ticks with labels" do 
    component = VerticalAxis.new( 
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
    File.open 'verticalaxis.svg', 'w' do |file|
      file.puts canvas.to_svg
    end
    expect(canvas.to_svg :partial).to eq(
      "<line x1='36' y1='6' x2='36' y2='206' style='stroke:black;'/>" +
      "<line x1='28' y1='156' x2='36' y2='156' style='stroke:black;'/>" +
      "<line x1='28' y1='106' x2='36' y2='106' style='stroke:black;'/>" +
      "<line x1='21' y1='56' x2='36' y2='56' style='stroke:black;'/>" +
      "<text x='1' y='60' style='font: italic 13px sans-serif'>30</text>" +
      "<line x1='28' y1='6' x2='36' y2='6' style='stroke:black;'/>"    )
  end

  it "should calculate ticks with lower bound of zero" do 
    component = VerticalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 40,
    )

    expect(component.ticks).to eq([
      [50,  false, '10'],
      [100, false, '20'],
      [150, true,  '30'],
      [200, false, '40'],
    ])
  end

  it "should calculate ticks with non-zero lower bound" do 
    component = VerticalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 10,
        value_upper_bound: 40,
    )

    expect(component.ticks).to eq([
      [0,   false, '10'],
      [50,  false, '20'],
      [100, true,  '30'],
      [150, false, '40'],
    ])
  end
end