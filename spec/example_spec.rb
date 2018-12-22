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
end