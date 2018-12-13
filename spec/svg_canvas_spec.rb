require 'spec_helper'

RSpec.describe Burnchart::SvgCanvas do
  it "orders arguments correctly" do
    canvas = Burnchart::SvgCanvas.new
    canvas.line y2: 1, x2: 2, y1: 3, x1: 4
    expect(canvas.to_svg :partial).to eq("<line x1='4' y1='3' x2='2' y2='1'/>")
  end

  it "handles text" do
    canvas = Burnchart::SvgCanvas.new
    canvas.text 'foo', x: 1, y: 2
    expect(canvas.to_svg :partial).to eq("<text x='1' y='2'>foo</text>")
  end

  it "writes full xml" do 
    canvas = Burnchart::SvgCanvas.new
    canvas.line x1: 1
    expect(canvas.to_svg :full).to eq(
      '<?xml version="1.0" standalone="no"?>' + "\n" +
      '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' + "\n" +
      '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' +
      '<line x1=\'1\'/></svg>')
  end
end

