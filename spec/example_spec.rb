require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in 
# documentation

RSpec.describe Burnchart::BurnDownChart do
  it "should create an example svg" do 
    chart = Burnchart::BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-05'),
        visible: true,
        day_width: 50
      },
      y_axis: {
        max_value: 30,
        visible: true, 
        point_height: 5
      },
      data_points: [
        DataPoint.new('2018-01-02', 10),
        DataPoint.new('2018-01-03', 15),
        DataPoint.new('2018-01-04', 15),
        DataPoint.new('2018-01-05', 8),
      ]
    )

    File.open 'example1.svg', 'w' do | file |
      file.puts chart.to_svg
    end
  end

  it "should illustrate usage" do 
    chart = SimpleChart.new
    chart.left_axis = VerticalAxis.new(
      units: Integer, min_value: 0, max_value: 20 #, title: 'lead times (days)'
    )
    chart.bottom_axis = HorizontalAxis.new(
      units: Date, min_value: Date.parse('2018-01-02'), max_value: Date.parse('2018-01-04')
    )
    # chart.data_layers << DataLayer.create do |layer|
    #   layer.renderers << SmoothLineChartRenderer.new(stroke: 'red')
    #   # layer.renderers << DotRenderer.new(stroke: 'black')
    # #   layer.data = [ 
    # #     Point.new(x:'2018-01-02', y:10),
    # #     Point.new(x:'2018-01-03', y:15),
    # #     Point.new(x:'2018-01-04', y:15),
    # #     Point.new(x:'2018-01-05', y:8),
    # #   ]
    # end

    File.open 'simple_chart.svg', 'w' do | file |
      file.puts chart.to_svg
    end    
  end
end