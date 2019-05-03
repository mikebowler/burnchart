# frozen_string_literal: true

require 'spec_helper'

module SolvingBits

  RSpec.describe SvgCanvas do
    it 'orders arguments correctly' do
      canvas = SvgCanvas.new
      canvas.line y2: 1, x2: 2, y1: 3, x1: 4
      expect(canvas.to_svg(:partial)).to eq("<line x1='4' y1='3' x2='2' y2='1'/>")
    end

    it 'handles text' do
      canvas = SvgCanvas.new
      canvas.text 'foo', x: 1, y: 2
      expect(canvas.to_svg(:partial)).to eq("<text x='1' y='2'>foo</text>")
    end

    it 'writes full xml' do
      canvas = SvgCanvas.new
      canvas.line x1: 1
      expect(canvas.to_svg(:full)).to eq(
        '<?xml version="1.0" standalone="no"?>' \
        "\n" \
        '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" ' \
        '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' \
        "\n" \
        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' \
        '<line x1=\'1\'/></svg>'
      )
    end

    it 'handles unexpected canvas type' do
      canvas = SvgCanvas.new
      canvas.line x1: 1
      expect { canvas.to_svg(:foo) }.to raise_error('unexpected svg flavour: :foo')
    end

    it 'handles unexpected command on primitive' do
      canvas = SvgCanvas.new
      expect { canvas.line x3: 1 }.to raise_error('x3 is not an attribute on svg line')
    end

    it 'handles nested elements' do
      canvas = SvgCanvas.new
      canvas.rect x: 0, y: 0, width: 100, height: 100 do
        canvas.title 'MyRect'
      end

      expect(canvas.to_svg(:partial)).to eq(
        "<rect x='0' y='0' width='100' height='100'>" \
        '<title>MyRect</title>' \
        '</rect>'
      )
    end
  end
end