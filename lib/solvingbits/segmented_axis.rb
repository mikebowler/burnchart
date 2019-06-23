# frozen_string_literal: true

module SolvingBits
  class SegmentedAxis < SvgComponent
    include Configurable

    attr_configurable :orientation, only: %i[vertical horizontal]

    attr_configurable :segments_keys, defaults_to: []
    attr_configurable :segments_height_px, defaults_to: 10
    attr_configurable :segments_width_px, defaults_to: 10
    attr_configurable :segments_font_size_px, defaults_to: 13

    def initialize params
      initialize_configuration params: params
    end

    def vertical?
      orientation() == :vertical
    end

    def render viewport
      if vertical?
        render_vertical viewport
      else
        render_horizontal viewport
      end
    end

    def render_horizontal viewport
      top_pad = 1
      padding_between = 1
      tick_length = 3

      viewport.canvas.line(
        x1: viewport.left,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.top,
        style: 'stroke:black;'
      )


      segments_keys.each_with_index do |key, index|
        left_edge = viewport.left + (segments_width_px() * index)
        viewport.canvas.text(
          key.to_s,
          x: left_edge + (segments_width_px() / 2),
          y: viewport.top + segments_font_size_px + top_pad,
          text_anchor: 'middle',
          dominant_baseline: 'top'
        )
      end
    end

    def render_vertical viewport
      left_pad = 1

      viewport.canvas.line(
        x1: viewport.right,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.bottom,
        style: 'stroke:black;'
      )

      segments_keys.each_with_index do |key, index|
        viewport.canvas.text(
          key.to_s,
          x: viewport.right - left_pad,
          y: viewport.bottom - (segments_height_px() * index) - (segments_height_px() / 2),
          text_anchor: 'end',
          dominant_baseline: 'middle'
        )
      end
    end


    def preferred_size
      if vertical?
        Size.new(
          width: segments_width_px(),
          height: segments_keys().length() * segments_height_px()
        )
      else
        Size.new(
          height: segments_height_px(),
          width: segments_keys().length() * segments_width_px()
        )
      end
    end
  end
end
