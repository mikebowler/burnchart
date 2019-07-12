# frozen_string_literal: true

module SolvingBits

  class StackItem
    include Configurable

    attr_configurable :value, defaults_to: 0
    attr_configurable :label
    attr_configurable :color, defaults_to: 'black'

    def initialize args
      initialize_configuration params: args
      @value = value[0] if value_is_range() && value[0] == value[1]
    end

    def value_is_range
      @value.is_a? Array
    end

    def min_value
      if value_is_range
        # return the higher end of the range
        @value[0]
      else
        @value
      end
    end

    def max_value
      if value_is_range
        # return the higher end of the range
        @value[1]
      else
        @value
      end
    end

    def single_value
      max_value
    end
  end

  class StackedBars < SvgComponent
    include Configurable

    attr_configurable :orientation, defaults_to: :vertical, only: %i[vertical horizontal]

    attr_configurable :values, defaults_to: []
    attr_configurable :bar_width_px, defaults_to: 10
    attr_configurable :gap, defaults_to: 0

    attr_configurable :range_handles_enabled, defaults_to: false, only: [true, false]
    attr_configurable :range_handles_color, defaults_to: 'black'
    attr_configurable :range_handles_gap, defaults_to: 1

    def initialize params = {}
      initialize_configuration params: params
      @stacks = []
    end

    def create_stack
      stack = []
      @stacks << stack
      yield stack
    end

    def stack_width
      width = bar_width_px()
      width += range_handles_gap() + 1 if range_handles_enabled()
      width
    end

    def preferred_size
      Size.new(
        height: @stacks.collect { |stack| stack.collect(&:single_value).sum }.max,
        width: (@stacks.count() * stack_width) + ((@stacks.count - 1) * gap())
      )
    end

    def render viewport
      remainder = viewport.width - (@stacks.length * bar_width_px()) - ((@stacks.count - 1) * gap())
      left = viewport.left + (remainder / 2)

      @stacks.each do |stack|
        bottom = viewport.bottom
        stack.each do |item|
          # range_handles_enabled = stack.any?(&:range_handles_enabled)

          value = item.max_value
          bar_height = viewport.vertical_axis&.value_to_length(value) || value

          if range_handles_enabled() && item.value_is_range 
            handle_height = viewport.vertical_axis&.value_to_length(value-item.min_value) || value
            viewport.canvas.rect(
              x: left,
              y: bottom - bar_height,
              width: bar_width_px(),
              height: handle_height,
              style: "stroke: #{item.color()}; fill: #{range_handles_color};"
            )
          end

          viewport.canvas.rect(
            x: range_handles_enabled() ? left + range_handles_gap() + 1 : left,
            y: bottom - bar_height,
            width: bar_width_px(),
            height: bar_height,
            style: "stroke: #{item.color}; fill: #{item.color};"
          ) { viewport.canvas.title item.label() unless item.label.nil? }

          bottom -= bar_height
        end
        left += stack_width + gap()
      end
    end
  end
end
