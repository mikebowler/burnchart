require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in 
# documentation

RSpec.describe Burnchart::BurnDownChart do
  it "should create an example svg" do 
    chart = Burnchart::BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-02'),
        visible: false,
        day_width: 50
      },
      y_axis: {
        max_value: 30,
        visible: false
      },
      data_points: [
        [Date.parse('2018-01-02'), 10],
        [Date.parse('2018-01-03'), 15],

      ]
    )

    File.open 'example1.svg', 'w' do | file |
      file.puts chart.to_svg
    end
  end
end