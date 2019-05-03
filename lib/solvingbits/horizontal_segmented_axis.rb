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

    def render viewport
      segments_keys.each_with_index do |key, index|
        left_edge = viewport.left + (segments_width_px() * index)
        viewport.canvas.text(
          key.to_s,
          x: left_edge + (segments_width_px() / 2),
          y: viewport.bottom,
          text_anchor: 'middle'
        )
      end
    end

    def preferred_size
      Size.new(
        height: segments_font_size_px(),
        width: segments_keys().length() * segments_width_px()
      )
    end
  end
end
