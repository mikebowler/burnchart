# frozen_string_literal: true

require 'spec_helper'
require 'date'

module SolvingBits
  RSpec.describe LinearAxis do
    context 'ticks' do
      it 'should calculate ticks with lower bound of zero' do
        component = LinearAxis.new(
         positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        expect(component.ticks).to eq(
          [
            [50,  false, '10'],
            [100, false, '20'],
            [150, true,  '30'],
            [200, false, '40']
          ]
        )
      end

      it 'should calculate ticks with non-zero lower bound' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 10, upper_bound: 40 }
        )

        expect(component.ticks).to eq(
          [
            [50,  false, '20'],
            [100, true,  '30'],
            [150, false, '40']
          ]
        )
      end

      it 'should include lower bound tick when asked' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5, show_lowest_value: true },
          major_ticks: { every: 30 },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        expect(component.ticks).to eq(
          [
            [0,   true, '0'],
            [50,  false, '10'],
            [100, false, '20'],
            [150, true,  '30'],
            [200, false, '40']
          ]
        )
      end

      it 'hide minor ticks when specified' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, visible: false, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        expect(component.ticks).to eq(
          [
            [150, true, '30']
          ]
        )
      end

      it 'should draw major ticks as minor when major ticks are hidden' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30, visible: false },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        expect(component.ticks).to eq(
          [
            [50,  false, '10'],
            [100, false, '20'],
            [150, false, '30'],
            [200, false, '40']
          ]
        )
      end

      it 'should reject lower bounds being higher than upper bounds' do
        expect do
          LinearAxis.new(
            positioning: { axis: 'bottom', origin: 'left' },
            minor_ticks: { every: 10, px_between: 5 },
            major_ticks: { every: 30 },
            values: { lower_bound: 40, upper_bound: 10 }
          )
        end.to raise_error('Lower bound must be less than upper: 40 > 10')
      end

      it "should reject major ticks if they aren't a multiple of minor" do
        expect do
          LinearAxis.new(
            positioning: { axis: 'bottom', origin: 'left' },
            minor_ticks: { every: 10, px_between: 5 },
            major_ticks: { every: 35 },
            values: { lower_bound: 10, upper_bound: 40 }
          )
        end.to raise_error('Major ticks must be a multiple of minor: 35 and 10')
      end

      # This is currently returning the wrong offsets per date
      it 'should calculate ticks with type of Date' do
        component = LinearAxis.new(
         positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 1, px_between: 10, show_lowest_value: true },
          major_ticks: { every: 1, visible: false },
          values: {
            lower_bound: Date.parse('2019-01-11'),
            upper_bound: Date.parse('2019-01-13'),
            unit: Date
          }
        )

        expect(component.ticks true).to eq(
          [
            [0,  false, '2019-01-11'],
            [10, false, '2019-01-12'],
            [20, false, '2019-01-13']
          ]
        )
      end

      it 'should calculate ticks with type of Time' do
        component = LinearAxis.new(
         positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 1, px_between: 10, show_lowest_value: true },
          major_ticks: { every: 1, visible: false },
          values: {
            lower_bound: Time.parse('2019-01-11T00:00Z'),
            upper_bound: Time.parse('2019-01-13T00:00Z'),
            unit: Date
          }
        )

        expect(component.ticks true).to eq(
          [
            [0,  false, '2019-01-11'],
            [10, false, '2019-01-12'],
            [20, false, '2019-01-13']
          ]
        )
      end

    end

    context 'axis: bottom, origin: left' do

      it 'should convert to coordinate space when lower value and coordinates are zero' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        inputs = [10, 20, 40]
        expected = [25, 50, 100]
        actual = inputs.collect do |i|
          component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
        end
        expect(actual).to eq(expected)
      end

      it 'should convert to coordinate space when lower value is offset and coordinates are not' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 10, upper_bound: 50 }
        )

        inputs = [20, 30, 50]
        expected = [25, 50, 100]
        actual = inputs.collect do |i|
          component.to_coordinate_space value: i, lower_coordinate: 0, upper_coordinate: 100
        end
        expect(actual).to eq(expected)
      end

      it 'should convert to coordinate space when lower coordinate is offset and value bounds are not' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        inputs = [10, 20, 40]
        expected = [35, 60, 110]
        actual = inputs.collect do |i|
          component.to_coordinate_space value: i, lower_coordinate: 10, upper_coordinate: 110
        end
        expect(actual).to eq(expected)
      end

      it 'should convert to coordinate space when value is a Time' do
        component = LinearAxis.new(
          positioning: { axis: 'bottom', origin: 'left' },
          minor_ticks: { every: 10, px_between: 5 },
          major_ticks: { every: 30 },
          values: {
            lower_bound: Date.parse('2019-01-01'),
            upper_bound: Date.parse('2019-01-02'),
            unit: Date
          }
        )

        inputs = [
          Date.parse('2019-01-01'),
          Time.parse('2019-01-01T00:00Z'),
          Time.parse('2019-01-01T06:00Z'),
          Time.parse('2019-01-01T12:00Z'),
          Time.parse('2019-01-01T18:00Z'),
          Time.parse('2019-01-02T00:00Z'),
          Date.parse('2019-01-02')
        ]
        expected = [0, 0, 25, 50, 75, 100, 100]
        actual = inputs.collect do |i|
          component.to_coordinate_space(
            value: i, lower_coordinate: 0, upper_coordinate: 100
          )
        end
        expect(actual).to eq(expected)
      end
    end

    context 'axis: left, origin: left' do
      xit 'should draw simple ticks' do
        component = LinearAxis.new(
          positioning: { axis: 'left', origin: 'bottom' },
          minor_ticks: { every: 10, length: 8, px_between: 5 },
          major_ticks: { every: 30, length: 15, label: { visible: false } },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        component.render Viewport.new left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='16' y1='0' x2='16' y2='200' style='stroke:black;'/>" \
          "<line x1='8' y1='150' x2='16' y2='150' style='stroke:black;'/>" \
          "<line x1='8' y1='100' x2='16' y2='100' style='stroke:black;'/>" \
          "<line x1='1' y1='50' x2='16' y2='50' style='stroke:black;'/>" \
          "<line x1='8' y1='0' x2='16' y2='0' style='stroke:black;'/>"
        )
      end

      xit 'should draw simple ticks with labels' do
        component = LinearAxis.new(
          positioning: { axis: 'left', origin: 'bottom' },
          minor_ticks: { every: 10, length: 8, px_between: 5 },
          major_ticks: { every: 30, length: 15, label: { visible: true } },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        component.render Viewport.new left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='36' y1='6' x2='36' y2='206' style='stroke:black;'/>" \
          "<line x1='28' y1='156' x2='36' y2='156' style='stroke:black;'/>" \
          "<line x1='28' y1='106' x2='36' y2='106' style='stroke:black;'/>" \
          "<line x1='21' y1='56' x2='36' y2='56' style='stroke:black;'/>" \
          "<text x='20' y='56' style='font: italic 13px sans-serif' " \
            "text-anchor='end' alignment-baseline='middle'>30</text>" \
          "<line x1='28' y1='6' x2='36' y2='6' style='stroke:black;'/>"
        )
      end

      xit 'should draw label' do
        component = LinearAxis.new(
          positioning: { axis: 'left', origin: 'bottom' },
          minor_ticks: { every: 10, length: 8, px_between: 5 },
          major_ticks: { every: 30, length: 15, label: { visible: false } },
          values: { lower_bound: 0, upper_bound: 40 },
          label: { visible: true, text: 'Time' }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        component.render Viewport.new left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='29' y1='0' x2='29' y2='200' style='stroke:black;'/>" \
          "<line x1='21' y1='150' x2='29' y2='150' style='stroke:black;'/>" \
          "<line x1='21' y1='100' x2='29' y2='100' style='stroke:black;'/>" \
          "<line x1='14' y1='50' x2='29' y2='50' style='stroke:black;'/>" \
          "<line x1='21' y1='0' x2='29' y2='0' style='stroke:black;'/>" \
          "<text x='13' y='0' style='font: 13px sans-serif' text-anchor='end' " \
            "transform='rotate(270, 13, 0)'>Time</text>"
        )
      end

      xit 'should draw background lines' do
        component = LinearAxis.new(
          positioning: { axis: 'left', origin: 'bottom' },
          minor_ticks: { every: 10, length: 8, px_between: 5 },
          major_ticks: { every: 10, length: 15, label: { visible: false } },
          values: { lower_bound: 0, upper_bound: 40 }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        component.background_line_renderer.render Viewport.new(
          left: 0,
          right: size.width,
          top: 0,
          bottom: size.height,
          canvas: canvas
        )
        expect(canvas.to_svg(:partial)).to eq(
          "<line x1='0' y1='150' x2='16' y2='150' style='stroke: lightgray'/>" \
          "<line x1='0' y1='100' x2='16' y2='100' style='stroke: lightgray'/>" \
          "<line x1='0' y1='50' x2='16' y2='50' style='stroke: lightgray'/>" \
          "<line x1='0' y1='0' x2='16' y2='0' style='stroke: lightgray'/>"
        )
      end
    end

    context 'positioning should be right with' do
      def test_positioning args
        component = LinearAxis.new(
          positioning: { axis: args[:axis], origin: args[:origin] },
          minor_ticks: { visible: false },
          major_ticks: { every: 10, length: 5, label: { visible: true } },
          values: { lower_bound: 0, upper_bound: 10 },
          label: { visible: true, text: 'Time' }
        )

        canvas = SvgCanvas.new
        size = component.preferred_size
        component.render Viewport.new(
          left: 0, right: size.width, top: 0, bottom: size.height, canvas: canvas
        )
        expect(component.calculations).to eq(args[:expected])
      end

      it 'axis bottom and origin left' do
        test_positioning(
          axis: 'bottom', origin: 'left',
          expected: { baseline: 0, label_baseline: 31, tick_label_baseline: 18, tick_label_center: 50 }
        )
      end

      it 'axis bottom and origin right' do
        test_positioning(
          axis: 'bottom', origin: 'right',
          expected: { baseline: 0, label_baseline: 31, tick_label_baseline: 18, tick_label_center: 0 }
        )
      end

      it 'axis top and origin left' do
        test_positioning(
          axis: 'top', origin: 'left',
          expected: { baseline: 31, label_baseline: 13, tick_label_baseline: 26, tick_label_center: 50 }
        )
      end

      it 'axis top and origin right' do
        test_positioning(
          axis: 'top', origin: 'right',
          expected: { baseline: 31, label_baseline: 13, tick_label_baseline: 26, tick_label_center: 0 }
        )
      end
    end
  end
end
