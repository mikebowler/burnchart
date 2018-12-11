RSpec.describe Burnchart do
  it "has a version number" do
    expect(Burnchart::VERSION).not_to be nil
  end

  # it "should return empty svg if no params specified" do
  #   chart = MockBurnchart.new
  #   expect(chart.to_svg).to eq('<svg width="0" height="0" />')
  #   expect(chart.draw_commands).to eq([
  #     'svg width:0 height:0'
  #   ])
  # end
end
