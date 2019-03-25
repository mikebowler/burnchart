require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in
# documentation

RSpec.describe 'Runnable examples' do
  it 'should illustrate usage' do
    chart = SimpleChart.new
    chart.left_axis = VerticalAxis.new(
      minor_ticks: { every: 1, length: 4, px_between: 5 },
      major_ticks: { every: 10, length: 8 },
      values: { lower_bound: 0, upper_bound: 30, unit: Integer },
      label: { visible: true, text: 'Lead time', font_size_px: 15 }
    )

    chart.bottom_axis = HorizontalAxis.new(
      values: { 
        unit: Date, 
        lower_bound: Date.parse('2018-01-02'),
        upper_bound: Date.parse('2018-01-16'),
        formatter: lambda { |value| "#{value.strftime '%b %e'}"}
      },
      minor_ticks: { every: 1, length: 4, px_between: 50, show_lowest_value: true },
      major_ticks: { every: 1, length: 4, label: { visible: true, font_size_px: 11 } },
      label: { visible: true, text: 'Story points', font_size_px: 15 }
    )
    chart.data_layers << DataLayer.create do |layer|
      layer.renderers << LineChartRenderer.new # (stroke: 'red')
      layer.renderers << DotChartRenderer.new # (stroke: 'black')
      layer.data = [
        Point.new(x: Date.parse('2018-01-02'), y: 25),
        Point.new(x: Date.parse('2018-01-03'), y: 21),
        Point.new(x: Date.parse('2018-01-04'), y: 23),
        Point.new(x: Date.parse('2018-01-05'), y: 17),
        Point.new(x: Date.parse('2018-01-06'), y: 11),
        Point.new(x: Date.parse('2018-01-07'), y: 6),
        Point.new(x: Date.parse('2018-01-08'), y: 2),
        Point.new(x: Date.parse('2018-01-09'), y: 0),
      ]
    end

    File.open 'simple_chart.svg', 'w' do |file|
      file.puts chart.to_svg
    end   
  end
end