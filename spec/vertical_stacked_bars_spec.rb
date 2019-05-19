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

    xit 'should render lots' do
      component = VerticalStackedBars.new
      component.create_stack do |stack|
        stack.add value: 5, label: 'committed', color: 'blue'
        stack.add value: 5, label: 'added', color: 'pink'
      end
      component.create_stack do |stack|
        stack.add value: 5, label: 'completed', color: 'green'
        stack.add value: 5, label: 'removed', color: 'orange'
        stack.add value: 5, label: 'incomplete', color: 'black'
      end

      File.open 'stacked.svg', 'w' do |file|
        file.puts component.to_svg
      end
      component.dump
      expect(component.to_svg(:partial)).to eq(
        "<line x1='0' y1='0' x2='300' y2='0' style='stroke:black;'/>" \
        "<text x='50' y='14' text-anchor='middle' alignment-baseline='top'>1</text>" \
        "<text x='150' y='14' text-anchor='middle' alignment-baseline='top'>2</text>" \
        "<text x='250' y='14' text-anchor='middle' alignment-baseline='top'>3</text>"
      )
    end
  end
end
