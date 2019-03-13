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
    # chart = Burnchart::Chart.new
    # chart.left_axis = HorizontalAxis.new(
    #   units: Date, min_value: Date.parse('2018-01-02'), max_value: Date.parse('2018-01-04')
    # )
    # chart.bottom_axis = VerticalAxis.new(
    #   units: fixnum, min_value: 0, max_value: 20, title: 'lead times (days)'
    # )
    # chart.data_layers << DataLayer.create do |layer|
    #   layer.renderers << SimpleLineChartRenderer.new(stroke: 'red')
    #   layer.renderers << DotRenderer.new(stroke: 'black')
    #   layer.data = [ 
    #     DataPoint.new('2018-01-02', 10),
    #     DataPoint.new('2018-01-03', 15),
    #     DataPoint.new('2018-01-04', 15),
    #     DataPoint.new('2018-01-05', 8),
    #   ]
    # end

    # File.open 'example-burndown.svg', 'w' do | file |
    #   file.puts chart.to_svg
    # end    
  end
end