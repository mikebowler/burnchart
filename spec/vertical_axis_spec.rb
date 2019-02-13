require 'spec_helper'
include Burnchart

RSpec.describe VerticalAxis do
  it "should default to basic size" do
    expect(VerticalAxis.new.preferred_size).to eql Size.new(height:500, width:8)
  end

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
    File.open 'verticalaxis.svg', 'w' do |file|
      file.puts canvas.to_svg
    end
    expect(canvas.to_svg :partial).to eq(
      "<line x1='16' y1='0' x2='16' y2='200' style='stroke:black;'/>" +
      "<line x1='1' y1='0' x2='16' y2='0' style='stroke:black;'/>" +
      "<line x1='8' y1='50' x2='16' y2='50' style='stroke:black;'/>" +
      "<line x1='8' y1='100' x2='16' y2='100' style='stroke:black;'/>" +
      "<line x1='1' y1='150' x2='16' y2='150' style='stroke:black;'/>" +
      "<line x1='8' y1='200' x2='16' y2='200' style='stroke:black;'/>"
    )
  end

end