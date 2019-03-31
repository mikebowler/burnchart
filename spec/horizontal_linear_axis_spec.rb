# frozen_string_literal: true

require 'spec_helper'
include SolvingBits

RSpec.describe HorizontalLinearAxis do
  it 'should draw simple ticks' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, label: { visible: false } },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='0' y1='0' x2='200' y2='0' style='stroke:black;'/>" \
      "<line x1='50' y1='0' x2='50' y2='8' style='stroke:black;'/>" \
      "<line x1='100' y1='0' x2='100' y2='8' style='stroke:black;'/>" \
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke:black;'/>" \
      "<line x1='200' y1='0' x2='200' y2='8' style='stroke:black;'/>"
    )
  end

  it 'should draw simple ticks with labels' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, label: { visible: true } },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='0' y1='0' x2='200' y2='0' style='stroke:black;'/>" \
      "<line x1='50' y1='0' x2='50' y2='8' style='stroke:black;'/>" \
      "<line x1='100' y1='0' x2='100' y2='8' style='stroke:black;'/>" \
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke:black;'/>" \
      "<text x='150' y='28' style='font: italic 13px sans-serif' text-anchor='middle'>30</text>" \
      "<line x1='200' y1='0' x2='200' y2='8' style='stroke:black;'/>"
    )
  end

  it 'should handle date ranges' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 1, length: 4, px_between: 50 },
      major_ticks: { every: 7, length: 8, label: { visible: true } },
      values: {
        lower_bound: Date.parse('2019-01-01'),
        upper_bound: Date.parse('2019-01-08'),
        unit: Date
      }
    )
    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='0' y1='0' x2='350' y2='0' style='stroke:black;'/>" \
      "<line x1='50' y1='0' x2='50' y2='4' style='stroke:black;'/>" \
      "<line x1='100' y1='0' x2='100' y2='4' style='stroke:black;'/>" \
      "<line x1='150' y1='0' x2='150' y2='4' style='stroke:black;'/>" \
      "<line x1='200' y1='0' x2='200' y2='4' style='stroke:black;'/>" \
      "<line x1='250' y1='0' x2='250' y2='4' style='stroke:black;'/>" \
      "<line x1='300' y1='0' x2='300' y2='8' style='stroke:black;'/>" \
      "<text x='300' y='21' style='font: italic 13px sans-serif' text-anchor='middle'>" \
      '2019-01-07</text>' \
      "<line x1='350' y1='0' x2='350' y2='4' style='stroke:black;'/>"
    )
  end

  it 'should draw label when no labels on ticks' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 30, length: 15, label: { visible: false } },
      values: { lower_bound: 0, upper_bound: 40 },
      label: { visible: true, text: 'Lead time', font_size_px: 13 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.render left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='0' y1='0' x2='200' y2='0' style='stroke:black;'/>" \
      "<line x1='50' y1='0' x2='50' y2='8' style='stroke:black;'/>" \
      "<line x1='100' y1='0' x2='100' y2='8' style='stroke:black;'/>" \
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke:black;'/>" \
      "<line x1='200' y1='0' x2='200' y2='8' style='stroke:black;'/>" \
      "<text x='200' y='28' style='font: 13px sans-serif' text-anchor='end'>Lead time</text>"
    )
  end

  it 'should draw background lines' do
    component = HorizontalLinearAxis.new(
      minor_ticks: { every: 10, length: 8, px_between: 5 },
      major_ticks: { every: 10, length: 15, label: { visible: false } },
      values: { lower_bound: 0, upper_bound: 40 }
    )

    canvas = SvgCanvas.new
    size = component.preferred_size
    component.background_line_renderer.render(
      left: 0,
      right: size.width,
      top: 0,
      bottom: size.height,
      canvas: canvas
    )
    expect(canvas.to_svg(:partial)).to eq(
      "<line x1='50' y1='0' x2='50' y2='15' style='stroke: lightgray'/>" \
      "<line x1='100' y1='0' x2='100' y2='15' style='stroke: lightgray'/>" \
      "<line x1='150' y1='0' x2='150' y2='15' style='stroke: lightgray'/>" \
      "<line x1='200' y1='0' x2='200' y2='15' style='stroke: lightgray'/>"
    )
  end
end
