# frozen_string_literal: true

module SolvingBits
  class HorizontalSegmentedAxis
    include Configurable

    attr_configurable :segments_keys, defaults_to: []
    attr_configurable :segments_height_px, defaults_to: 10
    attr_configurable :segments_width_px, defaults_to: 10
    attr_configurable :segments_font_size_px, defaults_to: 13

    # attr_configurable :formatter

    # attr_configurable :label_text
    # attr_configurable :label_visible, defaults_to: false, only: [true, false]
    # attr_configurable :label_font_size_px, defaults_to: 13

    def initialize params
      initialize_configuration params: params
    end

    def render left:, right:, top:, bottom:, canvas:
      canvas.line x1: left, y1: top, x2: right, y2: top, style: 'stroke:black;'
    end

    def preferred_size
      Size.new(
        height: values_font_size_px(),
        width: values_keys().length() * values_length_px()
      )
    end
  end
end
