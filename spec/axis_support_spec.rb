require 'spec_helper'
include Burnchart

# Since AxisSupport is a mixin, we test through HorizontalAxis
RSpec.describe AxisSupport do
  it "should calculate ticks with lower bound of zero" do 
    component = HorizontalAxis.new( 
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
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 10,
        value_upper_bound: 40,
    )

    expect(component.ticks).to eq([
      [50,  false, '20'],
      [100, true,  '30'],
      [150, false, '40'],
    ])
  end

  it "should reject lower bounds being higher than upper bounds" do
    expect { HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 40,
        value_upper_bound: 10,
    ) }.to raise_error('Lower bound must be less than upper: 40 > 10')
  end

  it "should reject major ticks if they aren't a multiple of minor" do
    expect { HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 35,
        px_between_ticks: 5,
        value_lower_bound: 10,
        value_upper_bound: 40,
    ) }.to raise_error('Major ticks must be a multiple of minor: 35 and 10')
  end

  it 'should convert to coordinate space when lower value and coordinates are zero' do 
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 40,
    )

    inputs = [10, 20, 40]
    expected = [25, 50, 100]
    actual = inputs.collect do |i| 
      component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
    end
    expect(actual).to eq(expected)
  end

  it 'should convert to coordinate space when lower value is offset and coordinates are not' do 
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 10,
        value_upper_bound: 50,
    )

    inputs = [20, 30, 50]
    expected = [25, 50, 100]
    actual = inputs.collect do |i| 
      component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
    end
    expect(actual).to eq(expected)
  end

  it 'should convert to coordinate space when lower coordinate is offset and value bounds are not' do 
    component = HorizontalAxis.new( 
        minor_ticks_every: 10,
        major_ticks_every: 30,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 40,
    )

    inputs = [10, 20, 40]
    expected = [35, 60, 110]
    actual = inputs.collect do |i| 
      component.to_coordinate_space value: i, lower_coordinate: 10, upper_coordinate: 110
    end
    expect(actual).to eq(expected)
  end
end
