require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in
# documentation

RSpec.describe 'Runnable examples' do
  it 'should illustrate usage' do
    chart = SimpleChart.new
    # chart.left_axis = VerticalAxis.new(
    #   minor_ticks_every: 1,
    #   minor_tick_length: 8,
    #   major_ticks_every: 10,
    #   major_tick_length: 15,
    #   display_value_for_major_ticks: true,
    #   px_between_ticks: 5,
    #   value_lower_bound: 0,
    #   value_upper_bound: 20
    #   # , title: 'lead times (days)'
    # )
    chart.left_axis = VerticalAxis.new(
      minor_ticks: { every: 1, length: 8 },
      major_ticks: { every: 10, length: 8 },
      values: { lower_bound: 0, upper_bound: 20, unit: Integer },
      px_between_ticks: 5,
      # fonts: { axis_label_size: 13, value_label_size: 11 }
    )

    chart.bottom_axis = HorizontalAxis.new(
      values: { 
        unit: Date, 
        lower_bound: Date.parse('2018-01-02'), 
        upper_bound: Date.parse('2018-01-05') 
      },
      minor_ticks: { every: 1, length: 4 },
      major_ticks: { every: 1, length: 15 },
      display_value_for_major_ticks: true,
      px_between_ticks: 100,
      display_lower_bound_tick: true
    )
    chart.data_layers << DataLayer.create do |layer|
      layer.renderers << SmoothLineChartRenderer.new # (stroke: 'red')
      layer.renderers << DotChartRenderer.new # (stroke: 'black')
      layer.data = [
        Point.new(x: Date.parse('2018-01-02'), y: 10),
        Point.new(x: Date.parse('2018-01-03'), y: 15),
        Point.new(x: Date.parse('2018-01-04'), y: 15),
        Point.new(x: Date.parse('2018-01-05'), y: 8)
      ]
    end

    File.open 'simple_chart.svg', 'w' do |file|
      file.puts chart.to_svg
    end   
  end
end