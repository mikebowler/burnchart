require 'spec_helper'
include Burnchart

RSpec.describe BurnDownChart do
  it "should draw single datapoint" do 
    chart = BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-02'),
        visible: false,
        day_width: 10
      },
      y_axis: {
        max_value: 30,
        visible: false,
        point_height: 2
      },
      options: {
        data_point_radius: 5
      },
      data_points: [
        DataPoint.new('2018-01-02', 10),
      ]
    )

    expect(chart.to_svg :partial).to eq("<circle cx='5' cy='40' r='5' fill='red'/>")
  end

  it "should draw multiple datapoints with lines between" do 
    chart = BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-04'),
        visible: false,
        day_width: 10
      },
      y_axis: {
        max_value: 30,
        visible: false,
        point_height: 2
      },
      options: {
        data_point_radius: 5
      },
      data_points: [
        DataPoint.new('2018-01-02', 15),
        DataPoint.new('2018-01-03', 10),
        DataPoint.new('2018-01-04', 8),
      ]
    )

    expect(chart.to_svg :partial).to eq(
      "<line x1='5' y1='30' x2='15' y2='40' style='stroke:red;'/>" +
      "<line x1='15' y1='40' x2='25' y2='44' style='stroke:red;'/>" +
      "<circle cx='5' cy='30' r='5' fill='red'/>" +
      "<circle cx='15' cy='40' r='5' fill='red'/>" +
      "<circle cx='25' cy='44' r='5' fill='red'/>" 
    )
  end

  it "should draw axis' with a single datapoint" do 
    chart = BurnDownChart.new(
      x_axis: { 
        start_date: Date.parse('2018-01-02'), 
        end_date: Date.parse('2018-01-02'),
        visible: true,
        day_width: 10
      },
      y_axis: {
        max_value: 30,
        visible: true,
        point_height: 2
      },
      options: {
        data_point_radius: 5
      },
      data_points: [
        DataPoint.new('2018-01-02', 10),
      ]
    )

    expect(chart.to_svg :partial).to eq(
      "<line x1='0' y1='0' x2='0' y2='60' style='stroke:#000;'/>" +
      "<line x1='0' y1='60' x2='10' y2='60' style='stroke:#000;'/>" +

      "<circle cx='5' cy='40' r='5' fill='red'/>")
  end
end

# x_axis: { label: 'foo', start_date: '', end_date: '', excluded_dates: [] }
# y_axis: { label: 'bar', max_value: 50, show_values: false }
# options: { show_perfect_line: false, heading: 'my data'}
# data_points: []