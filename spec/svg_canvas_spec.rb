RSpec.describe Burnchart::SvgCanvas do
  it "orders arguments correctly" do
    canvas = Burnchart::SvgCanvas.new
    canvas.line y2: 1, x2: 2, y1: 3, x1: 4
    expect(canvas.to_svg :partial).to eq(
      "<line x1='4' y1='3' x2='2' y2='1'/>")
  end

  it "handles text" do
    canvas = Burnchart::SvgCanvas.new
    canvas.text 'foo', x: 1, y: 2
    expect(canvas.to_svg :partial).to eq(
      "<text x='1' y='2'>foo</text>")
  end

end