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
end
