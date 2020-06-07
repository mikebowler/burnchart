# frozen_string_literal: true

require 'spec_helper'

# The purpose of this "spec" is to generate some samples that can be used in
# documentation
RSpec.describe 'Runnable examples' do
  it 'should show burndown chart' do
    chart = SolvingBits::SimpleChart.new
    chart.left_axis = y_axis = SolvingBits::LinearAxis.new(
      positioning: { axis: 'left', origin: 'bottom' },
      minor_ticks: { every: 1, length: 4, px_between: 5 },
      major_ticks: { every: 10, length: 8 },
      values: { lower_bound: 0, upper_bound: 30 },
      label: { visible: true, text: 'Story points', font_size_px: 15 }
    )

    chart.bottom_axis = SolvingBits::LinearAxis.new(
      positioning: { axis: 'bottom', origin: 'left' },
      values: {
        unit: Date,
        lower_bound: Date.parse('2018-01-02'),
        upper_bound: Date.parse('2018-01-16'),
        formatter: ->(value) { value.strftime '%b %e' }
      },
      minor_ticks: { every: 1, length: 4, px_between: 50, show_lowest_value: true },
      major_ticks: { every: 1, length: 4, label: { visible: true, font_size_px: 11 } },
      label: { visible: true, text: 'Dates', font_size_px: 15 }
    )
    chart.data_layers << SolvingBits::DataLayer.create do |layer|
      layer.renderers << y_axis.background_line_renderer
      layer.renderers << SolvingBits::LineChartRenderer.new # (stroke: 'red')
      layer.renderers << SolvingBits::DotRenderer.new
      layer.renderers << SolvingBits::LineMarkerRenderer.new(value: Date.parse('2018-01-04'))

      layer.data = [
        SolvingBits::Point.new(x: Date.parse('2018-01-02'), y: 25),
        SolvingBits::Point.new(x: Date.parse('2018-01-03'), y: 20),
        SolvingBits::Point.new(x: Date.parse('2018-01-04'), y: 23),
        SolvingBits::Point.new(x: Date.parse('2018-01-05'), y: 17),
        SolvingBits::Point.new(x: Date.parse('2018-01-06'), y: 11),
        SolvingBits::Point.new(x: Date.parse('2018-01-07'), y: 6),
        SolvingBits::Point.new(x: Date.parse('2018-01-08'), y: 2),
        SolvingBits::Point.new(x: Date.parse('2018-01-09'), y: 0)
      ]
    end

    File.open 'burndown.svg', 'w' do |file|
      file.puts chart.to_svg
    end
  end

  it 'should create In/Out chart' do
    # -- start --
    chart = SolvingBits::SimpleChart.new
    chart.left_axis = y_axis = SolvingBits::LinearAxis.new(
      positioning: { axis: 'left', origin: 'bottom' },
      minor_ticks: { every: 1, length: 4, px_between: 5 },
      major_ticks: { every: 10, length: 8 },
      values: { lower_bound: 0, upper_bound: 30, unit: Integer },
      label: { visible: true, text: 'Story points', font_size_px: 15 }
    )

    chart.bottom_axis = SolvingBits::SegmentedAxis.new(
      orientation: :horizontal,
      segments: {
        keys: [
          'Sprint 3', # Sprint.new
          5
        ],
        font_size_px: 13,
        width_px: 100,
        height_px: 13
      }
    )

    chart.data_layers << SolvingBits::DataLayer.create do |layer|
      component = SolvingBits::StackedBars.new orientation: :vertical
      component.create_stack do |stack|
        stack << SolvingBits::StackItem.new(value: 5, label: 'committed', color: 'blue')
        stack << SolvingBits::StackItem.new(value: 5, label: 'added', color: 'pink')
      end
      component.create_stack do |stack|
        stack << SolvingBits::StackItem.new(value: 5, label: 'completed', color: 'green')
        stack << SolvingBits::StackItem.new(value: 5, label: 'removed', color: 'orange')
        stack << SolvingBits::StackItem.new(value: 5, label: 'incomplete', color: 'black')
      end
      layer.renderers << component


      # layer.renderers << y_axis.background_line_renderer
      # layer.renderers << LineChartRenderer.new # (stroke: 'red')
      # layer.renderers << DotRenderer.new

      # layer.data = [
      #   Point.new(x: Sprint.new, y: SprintData.new),
      #   Point.new(x: Sprint.new, y: SprintData.new)
      # ]
    end

    # -- end --
    File.open 'in_out_chart.svg', 'w' do |file|
      file.puts chart.to_svg
    end
  end

  it 'should show all combinations of linear axis' do
    outer_flow_panel = SolvingBits::FlowPanel.new orientation: :vertical, gap: 5, debug: true
    [
      %w[bottom left],
      %w[bottom right],
      %w[top left],
      %w[top right]
    ].each do |axis, origin|
      outer_flow_panel.add SolvingBits::LinearAxis.new(
        positioning: { axis: axis, origin: origin },
        minor_ticks: { every: 1, px_between: 5, length: 4 },
        major_ticks: { every: 10 },
        values: { lower_bound: 0, upper_bound: 40 },
        label: { text: "axis: #{axis} origin: #{origin}", visible: true }
      )
    end

    inner_flow_panel = SolvingBits::FlowPanel.new orientation: :horizontal, gap: 5, debug: true
    outer_flow_panel.add inner_flow_panel

    [
      %w[right top],
      %w[right bottom],
      %w[left top],
      %w[left bottom]
    ].each do |axis, origin|
      inner_flow_panel.add SolvingBits::LinearAxis.new(
        positioning: { axis: axis, origin: origin },
        minor_ticks: { every: 1, px_between: 5, length: 4 },
        major_ticks: { every: 10, length: 4 },
        values: { lower_bound: 0, upper_bound: 40 },
        label: { text: "axis: #{axis} origin: #{origin}", visible: true }
      )
    end

    File.open 'all_linear_axis.svg', 'w' do |file|
      file.puts outer_flow_panel.to_svg :full
    end
  end
end
