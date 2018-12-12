require 'spec_helper'

RSpec.describe Burnchart::BurnDownChart do
  it "should return empty svg if no params specified" do
    chart = Burnchart::BurnDownChart.new
    expect(chart.to_svg :partial).to eq('')
  end
end
