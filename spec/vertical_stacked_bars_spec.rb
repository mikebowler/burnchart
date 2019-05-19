# frozen_string_literal: true

module SolvingBits
  RSpec.describe VerticalStackedBars do
    it 'should render a single data point' do
      component = VerticalStackedBars.new
      component.create_stack do |stack|
        stack << StackItem.new(value: 5, label: 'committed', color: 'blue')
      end

      expect(component.preferred_size).to eq(Size.new(height: 5, width: 10))

      expect(component.to_svg(:partial)).to eq(
        "<rect x='0' y='0' width='10' height='5' style='fill: blue'/>"
      )
    end

    it 'should render multiple stacks with multiple items per stack' do
      component = VerticalStackedBars.new
      component.create_stack do |stack|
        stack << StackItem.new(value: 5, label: 'committed', color: 'blue')
        stack << StackItem.new(value: 5, label: 'added', color: 'pink')
      end
      component.create_stack do |stack|
        stack << StackItem.new(value: 5, label: 'completed', color: 'green')
        stack << StackItem.new(value: 5, label: 'removed', color: 'orange')
        stack << StackItem.new(value: 5, label: 'incomplete', color: 'black')
      end

      # File.open 'stacked.svg', 'w' do |file|
      #   file.puts component.to_svg
      # end
      # component.dump
      expect(component.to_svg(:partial)).to eq(
        "<rect x='0' y='10' width='10' height='5' style='fill: blue'/>" \
        "<rect x='0' y='5' width='10' height='5' style='fill: pink'/>" \
        "<rect x='10' y='10' width='10' height='5' style='fill: green'/>" \
        "<rect x='10' y='5' width='10' height='5' style='fill: orange'/>" \
        "<rect x='10' y='0' width='10' height='5' style='fill: black'/>"
      )
    end
  end
end
