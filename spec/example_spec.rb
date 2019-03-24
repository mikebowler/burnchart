require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in
# documentation

RSpec.describe 'Runnable examples' do
  it 'should illustrate usage' do
    chart = SimpleChart.new
    chart.left_axis = VerticalAxis.new(
      minor_ticks: { every: 1, length: 4, px_between: 5 },
      major_ticks: { every: 10, length: 8 },
      values: { lower_bound: 0, upper_bound: 20, unit: Integer },
      # fonts: { axis_label_size: 13, value_label_size: 11 }
      # , title: 'lead times (days)'
    )

    chart.bottom_axis = HorizontalAxis.new(
      values: { 
        unit: Date, 
        lower_bound: Date.parse('2018-01-02'),
        upper_bound: Date.parse('2018-01-16'),
        formatter: lambda { |value| "#{value.strftime '%b %e'}"}
      },
      minor_ticks: { every: 1, length: 4, px_between: 50, show_lowest_value: true },
      major_ticks: { every: 1, length: 4, show_label: true },
    )
    chart.data_layers << DataLayer.create do |layer|
      layer.renderers << SmoothLineChartRenderer.new # (stroke: 'red')
      layer.renderers << DotChartRenderer.new # (stroke: 'black')
      layer.data = [
        Point.new(x: Date.parse('2018-01-02'), y: 10),
        Point.new(x: Date.parse('2018-01-03'), y: 15),
        Point.new(x: Date.parse('2018-01-04'), y: 15),
        Point.new(x: Date.parse('2018-01-05'), y: 8),
        Point.new(x: Date.parse('2018-01-06'), y: 7),
        Point.new(x: Date.parse('2018-01-07'), y: 4),
        Point.new(x: Date.parse('2018-01-08'), y: 2),
        Point.new(x: Date.parse('2018-01-09'), y: 0),
      ]
    end

    File.open 'simple_chart.svg', 'w' do |file|
      file.puts chart.to_svg
    end   
  end
end