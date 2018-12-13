require 'spec_helper'

RSpec.describe Burnchart::BurnDownChart do
  it "should return empty svg if no params specified" do
    chart = Burnchart::BurnDownChart.new
    expect(chart.to_svg :partial).to eq('')
  end

  it "should draw single datapoint" do 
    chart = Burnchart::BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-02'),
        visible: false,
        day_width: 10
      },
      y_axis: {
        max_value: 30,
        visible: false
      },
      options: {
        data_point_radius: 5
      },
      data_points: [
        [Date.parse('2018-01-02'), 10]
      ]
    )

    expect(chart.to_svg :partial).to eq("<circle cx='5' cy='20' r='5' fill='red'/>")
  end
end

# x_axis: { label: 'foo', start_date: '', end_date: '', excluded_dates: [] }
# y_axis: { label: 'bar', max_value: 50, show_values: false }
# options: { show_perfect_line: false, heading: 'my data'}
# data_points: []