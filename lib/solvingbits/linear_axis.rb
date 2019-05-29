# frozen_string_literal: true


require 'date'

module SolvingBits
  class LinearAxis < SvgComponent
    include Configurable

    attr_configurable :positioning_axis, only: %w[top bottom left right]
    attr_configurable :positioning_origin, only: %w[top bottom left right]

    attr_configurable :minor_ticks_every, defaults_to: 1
    attr_configurable :minor_ticks_length, defaults_to: 4
    attr_configurable :minor_ticks_visible, defaults_to: true
    attr_configurable :minor_ticks_px_between, defaults_to: 5
    # Often we don't want to display a tick at the 'zero' value
    attr_configurable :minor_ticks_show_lowest_value, defaults_to: false

    attr_configurable :major_ticks_every, defaults_to: 1
    attr_configurable :major_ticks_length, defaults_to: 7
    attr_configurable :major_ticks_visible, defaults_to: true, only: [true, false]
    attr_configurable :major_ticks_label_visible, defaults_to: true, only: [true, false]
    attr_configurable :major_ticks_label_font_size_px, defaults_to: 13

    attr_configurable :values_lower_bound, defaults_to: 0
    attr_configurable :values_upper_bound, defaults_to: 100
    attr_configurable :values_unit, defaults_to: Integer, only: [Integer, Date]
    attr_configurable :values_formatter

    attr_configurable :label_text
    attr_configurable :label_visible, defaults_to: false, only: [true, false]
    attr_configurable :label_font_size_px, defaults_to: 13

    attr_configurable :estimated_char_width, defaults_to: 10

    def initialize params = {}
      initialize_configuration params: params

      self.values_lower_bound = convert_to_internal_value(values_lower_bound())
      self.values_upper_bound = convert_to_internal_value(values_upper_bound())

      if values_lower_bound() > values_upper_bound()
        raise 'Lower bound must be less than upper: ' \
          "#{values_lower_bound()} > #{values_upper_bound()}"
      end

      unless (major_ticks_every() % minor_ticks_every()).zero?
        raise 'Major ticks must be a multiple of minor: ' \
          "#{major_ticks_every()} and #{minor_ticks_every()}"
      end

      validate_positioning_arguments
    end

    def validate_positioning_arguments
      legal_combinations = [
        %w[bottom left],
        %w[bottom right],
        %w[left bottom],
        %w[left top],
      ]
      return if legal_combinations.include? [positioning_axis(), positioning_origin()]

      raise "Invalid positioning combination: axis=#{positioning_axis()} " \
        "origin=#{positioning_origin()}"
    end

    def label_width text
      text.to_s.length * estimated_char_width
    end

    # The internal represention that we use for the value may not be the same
    # as what's passed in. Convert.
    def convert_to_internal_value value
      if values_unit() == Date
        value.jd
      else
        value
      end
    end

    # The internal represention that we use for the value may not be the same
    # as what's passed in. Convert.
    def convert_to_external_value value
      if values_unit() == Date
        Date.jd(value)
      else
        value
      end
    end

    # Returns an array of these: [px_position, is_major_tick, label]
    def ticks
      formatter = values_formatter() || ->(value) { value.to_s }
      lower = values_lower_bound()
      upper = values_upper_bound()

      result = []
      offset = lower * minor_ticks_px_between()
      first_tick = lower - (lower % minor_ticks_every())
      if minor_ticks_show_lowest_value() == false && first_tick == lower
        first_tick = lower + minor_ticks_every()
      end

      first_tick.step(upper, minor_ticks_every()) do |value|
        is_major_tick = (value % major_ticks_every()).zero? && major_ticks_visible()

        next if is_major_tick == false && minor_ticks_visible() == false

        result << [
          value * minor_ticks_px_between() - offset,
          is_major_tick,
          formatter.call(convert_to_external_value(value))
        ]
      end
      result
    end

    def to_coordinate_space value:, lower_coordinate:, upper_coordinate:
      value = convert_to_internal_value value

      value_delta = values_upper_bound() - values_lower_bound()
      value_percent = (value - values_lower_bound()) * 1.0 / value_delta

      coordinate_delta = upper_coordinate - lower_coordinate

      # Ugly hack to account for the fact that the 0,0 origin is top left not
      # bottom left which in turn means that for horizontal axis, as the value
      # increases, so does the coordinate values. For the vertical axis, as the
      # value increases, the coordinate values decrease.
      if coordinate_values_move_in_same_direction_as_data_values?
        (coordinate_delta * value_percent).to_i + lower_coordinate
      else
        upper_coordinate - ((coordinate_delta - top_pad()) * value_percent).to_i
      end
    end

    def coordinate_values_move_in_same_direction_as_data_values?
      %w[left top].include? positioning_origin() 
    end

    def vertical?
      %w[left right].include? positioning_axis()
    end
    
    def render viewport
      if vertical?
        render_vertical viewport
      else
        render_horizontal viewport
      end
    end

    def render_horizontal viewport
      viewport.canvas.line(
        x1: viewport.left,
        y1: viewport.top,
        x2: viewport.right,
        y2: viewport.top,
        style: 'stroke:black;'
      )

      major_tick_bottom_edge = viewport.top + major_ticks_length
      minor_tick_bottom_edge = viewport.top + minor_ticks_length

      ticks.each do |x, is_major_tick, label|
        adjusted_x = if coordinate_values_move_in_same_direction_as_data_values?
          x + viewport.left
        else
          viewport.right - x
        end

        tick_bottom_edge = (is_major_tick ? major_tick_bottom_edge : minor_tick_bottom_edge)
        viewport.canvas.line(
          x1: adjusted_x,
          y1: viewport.top,
          x2: adjusted_x,
          y2: tick_bottom_edge,
          style: 'stroke:black;'
        )
        
        if major_ticks_label_visible() && is_major_tick
          viewport.canvas.text(
            label,
            x: adjusted_x,
            y: major_tick_bottom_edge + major_ticks_label_font_size_px(),
            style: "font: italic #{major_ticks_label_font_size_px()}px sans-serif",
            text_anchor: 'middle'
          )
        end
      end

      if label_visible()
        viewport.canvas.text(
          label_text(),
          x: viewport.right,
          y: viewport.bottom,
          style: "font: #{label_font_size_px()}px sans-serif",
          text_anchor: 'end'
        )
      end
    end

    def preferred_size
      height, width = 0, 0
      if vertical?
        width = major_ticks_length() + 1
        width += label_width(values_upper_bound().to_s) if major_ticks_label_visible()
        width += label_font_size_px() if label_visible()

        height = (values_upper_bound() * minor_ticks_px_between()).to_i + top_pad
      else
        height = major_ticks_length
        height += major_ticks_label_font_size_px() if major_ticks_label_visible()
        height += label_font_size_px() if label_visible()

        delta = values_upper_bound - values_lower_bound
        width = (delta * minor_ticks_px_between).to_i
      end

      Size.new height: height, width: width
    end

    # We need the top pad to ensure we aren't truncating labels
    # TODO: Be smarter about this. We only need the padding if there is a label right at the
    # top and today we're always putting padding just in case
    def top_pad
      if major_ticks_label_visible()
        major_ticks_label_font_size_px() / 2
      else
        0
      end
    end

    def render_vertical viewport
      top = viewport.top + top_pad
      viewport.canvas.line(
        x1: viewport.right,
        y1: top,
        x2: viewport.right,
        y2: viewport.bottom,
        style: 'stroke:black;'
      )

      major_tick_left_edge = viewport.right - major_ticks_length
      minor_tick_left_edge = viewport.right - minor_ticks_length

      ticks.each do |y, is_major_tick, label|
        adjusted_y = if coordinate_values_move_in_same_direction_as_data_values?
          viewport.top + y
        else
          viewport.bottom - y
        end

        tick_left_edge = (is_major_tick ? major_tick_left_edge : minor_tick_left_edge)
        viewport.canvas.line(
          x1: tick_left_edge,
          y1: adjusted_y,
          x2: viewport.right,
          y2: adjusted_y,
          style: 'stroke:black;'
        )
        if major_ticks_label_visible() && is_major_tick
          viewport.canvas.text(
            label,
            x: tick_left_edge - 1,
            y: adjusted_y,
            style: "font: italic #{major_ticks_label_font_size_px}px sans-serif",
            text_anchor: 'end',
            alignment_baseline: 'middle'
          )
        end
      end

      if label_visible()
        x_rotation = viewport.left + label_font_size_px()
        y_rotation = top

        viewport.canvas.text(
          label_text(),
          x: x_rotation,
          y: y_rotation,
          style: "font: #{label_font_size_px()}px sans-serif",
          transform: "rotate(270, #{x_rotation}, #{y_rotation})",
          text_anchor: 'end'
        )
      end

    end

    class HorizontalBackgroundLineRenderer
      include Configurable
      attr_configurable :color, defaults_to: 'lightgray'
      def initialize axis
        @axis = axis
      end

      def render viewport
        @axis.ticks.each do |x, is_major_tick, _label|
          next unless is_major_tick
          next if x.zero? # Don't draw over the y axis, regardless of settings

          viewport.canvas.line(
            x1: viewport.left + x,
            y1: viewport.top,
            x2: viewport.left + x,
            y2: viewport.bottom,
            style: "stroke: #{color()}"
          )
        end
      end
    end

    class VerticalBackgroundLineRenderer
      include Configurable
      attr_configurable :color, defaults_to: 'lightgray'
      def initialize axis
        @axis = axis
      end

      def render viewport
        @axis.ticks.each do |y, is_major_tick, _label|
          next unless is_major_tick
          next if y.zero? # Don't draw over the x axis, regardless of settings

          viewport.canvas.line(
            x1: viewport.left,
            y1: viewport.bottom - y,
            x2: viewport.right,
            y2: viewport.bottom - y,
            style: "stroke: #{color()}"
          )
        end
      end
    end

    def background_line_renderer
      if vertical?
        VerticalBackgroundLineRenderer.new(self)
      else
        HorizontalBackgroundLineRenderer.new(self)
      end
    end
  end
end