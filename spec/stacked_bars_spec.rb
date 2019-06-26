# frozen_string_literal: true

module SolvingBits
  RSpec.describe StackedBars do
    context 'vertical' do
      it 'should render a single data point' do
        component = StackedBars.new
        component.create_stack do |stack|
          stack << StackItem.new(value: 5, label: 'committed', color: 'blue')
        end

        expect(component.preferred_size).to eq(Size.new(height: 5, width: 10))

        expect(component.to_svg(:partial)).to eq(
          "<rect x='0' y='0' width='10' height='5' style='stroke: blue; fill: blue;'>" \
            "<title>committed</title>" \
          "</rect>"
      )
      end

      it 'should render multiple stacks with multiple items per stack' do
        component = StackedBars.new
        component.create_stack do |stack|
          stack << StackItem.new(value: 5, label: 'committed', color: 'blue')
          stack << StackItem.new(value: 5, label: 'added', color: 'pink')
        end
        component.create_stack do |stack|
          stack << StackItem.new(value: 5, label: 'completed', color: 'green')
          stack << StackItem.new(value: 5, label: 'removed', color: 'orange')
          stack << StackItem.new(value: 5, color: 'black')
        end

        expect(component.to_svg(:partial)).to eq(
          "<rect x='0' y='10' width='10' height='5' style='stroke: blue; fill: blue;'>" \
            "<title>committed</title>" \
          "</rect>" \
          "<rect x='0' y='5' width='10' height='5' style='stroke: pink; fill: pink;'>" \
            "<title>added</title>" \
          "</rect>" \
          "<rect x='10' y='10' width='10' height='5' style='stroke: green; fill: green;'>" \
            "<title>completed</title>" \
          "</rect>" \
          "<rect x='10' y='5' width='10' height='5' style='stroke: orange; fill: orange;'>" \
            "<title>removed</title>" \
          "</rect>" \
          "<rect x='10' y='0' width='10' height='5' style='stroke: black; fill: black;'>" \
          "</rect>"
        )
      end
    end

    it 'should render range handles' do
      component = StackedBars.new range_handles: { enabled: true, color: 'black', gap: 2 }
      component.create_stack do |stack|
        stack << StackItem.new(
          value: [10, 15],
          label: 'ranges',
          color: 'blue'
        )
      end

      expect(component.preferred_size).to eq(Size.new(height: 15, width: 13))
      expect(component.to_svg(:partial)).to eq(
        "<rect x='1' y='0' width='10' height='15' style='stroke: blue; fill: none;'/>" \
        "<rect x='4' y='0' width='10' height='15' style='stroke: blue; fill: blue;'>" \
          "<title>ranges</title>" \
        "</rect>"
      )
    end
  end
end
