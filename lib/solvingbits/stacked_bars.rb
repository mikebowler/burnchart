# frozen_string_literal: true

module SolvingBits

  class StackItem
    include Configurable

    attr_configurable :value, defaults_to: 0
    attr_configurable :label
    attr_configurable :color, defaults_to: 'black'

    def initialize args
      initialize_configuration params: args
    end
  end

  class StackedBars < SvgComponent
    include Configurable

    attr_configurable :orientation, defaults_to: :vertical, only: %i[vertical horizontal]

    attr_configurable :values, defaults_to: []
    attr_configurable :bar_width_px, defaults_to: 10

    def initialize params = {}
      initialize_configuration params: params
      @stacks = []
    end

    def create_stack
      stack = []
      @stacks << stack
      yield stack
    end

    def preferred_size
      Size.new(
        height: @stacks.collect { |stack| stack.collect(&:value).sum }.max,
        width: @stacks.count * bar_width_px()
      )
    end

    def render viewport
      left = viewport.left
      @stacks.each do |stack|
        bottom = viewport.bottom
        stack.each do |item|
          adjusted_height = viewport.vertical_adjust item.value
          viewport.canvas.rect(
            x: left,
            y: bottom - adjusted_height,
            width: bar_width_px(),
            height: adjusted_height,
            style: "fill: #{item.color}"
          ) { viewport.canvas.title item.label() unless item.label.nil? }

          bottom -= adjusted_height
        end
        left += bar_width_px()
      end
    end
  end
end
