# frozen_string_literal: true

require 'spec_helper'
require 'date'
include SolvingBits

# Since AbstractAxis is a mixin, we test through HorizontalLinearAxis
RSpec.describe AbstractLinearAxis do
  it 'should calculate ticks with lower bound of zero' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    expect(component.ticks).to eq([
      [50,  false, '10'],
      [100, false, '20'],
      [150, true,  '30'],
      [200, false, '40']
    ])
  end

  it 'should calculate ticks with non-zero lower bound' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 10, upper_bound: 40 }
    )

    expect(component.ticks).to eq(
      [
        [50,  false, '20'],
        [100, true,  '30'],
        [150, false, '40']
      ]
    )
  end

  it "should include lower bound tick when asked" do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5, show_lowest_value: true },
      major_ticks: { every: 30 },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    expect(component.ticks).to eq(
      [
        [0,   true, '0'],
        [50,  false, '10'],
        [100, false, '20'],
        [150, true,  '30'],
        [200, false, '40'],
      ]
    )
  end

  it 'hide minor ticks when specified' do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, visible: false, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    expect(component.ticks).to eq(
      [
        [150, true, '30']
      ]
    )
  end

  it 'should draw major ticks as minor when major ticks are hidden' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30, visible: false },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    expect(component.ticks).to eq(
      [
        [50,  false, '10'],
        [100, false, '20'],
        [150, false, '30'],
        [200, false, '40']
      ]
    )
  end

  it "should reject lower bounds being higher than upper bounds" do
    expect { HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 40, upper_bound: 10 }
    ) }.to raise_error('Lower bound must be less than upper: 40 > 10')
  end

  it "should reject major ticks if they aren't a multiple of minor" do
    expect { HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 35 },
      values: { lower_bound: 10, upper_bound: 40 }
    ) }.to raise_error('Major ticks must be a multiple of minor: 35 and 10')
  end

  it 'should convert to coordinate space when lower value and coordinates are zero' do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    inputs = [10, 20, 40]
    expected = [25, 50, 100]
    actual = inputs.collect do |i|
      component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
    end
    expect(actual).to eq(expected)
  end

  it 'should convert to coordinate space when lower value is offset and coordinates are not' do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 10, upper_bound: 50 }
    )

    inputs = [20, 30, 50]
    expected = [25, 50, 100]
    actual = inputs.collect do |i|
      component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
    end
    expect(actual).to eq(expected)
  end

  it 'should convert to coordinate space when lower coordinate is offset and value bounds are not' do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    inputs = [10, 20, 40]
    expected = [35, 60, 110]
    actual = inputs.collect do |i|
      component.to_coordinate_space value: i, lower_coordinate: 10, upper_coordinate: 110
    end
    expect(actual).to eq(expected)
  end

  it 'should convert to coordinate space when value is date' do 
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, px_between: 5 },
      major_ticks: { every: 30 },
      values: {
        lower_bound: Date.parse('2019-01-01'),
        upper_bound: Date.parse('2019-01-05'),
        unit: Date
      }
    )

    inputs = [Date.parse('2019-01-02')]
    expected = [25]
    actual = inputs.collect do |i| 
      component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
    end
    expect(actual).to eq(expected)
  end
end
