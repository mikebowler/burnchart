# frozen_string_literal: true

require 'bigdecimal'
require 'date'

module SolvingBits
  SECONDS_PER_DAY = BigDecimal(60 * 60 * 24)
  class LinearAxis < SvgComponent
    include Configurable

    attr_reader :calculations
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
      @calculations = {}
      initialize_configuration params: params

      @values_lower_bound = fix_ambigious_value values_lower_bound()
      @values_upper_bound = fix_ambigious_value values_upper_bound()

      @values_lower_bound_internal = convert_to_internal_value(values_lower_bound())
      @values_upper_bound_internal = convert_to_internal_value(values_upper_bound())

      if values_lower_bound() > values_upper_bound()
        raise 'Lower bound must be less than upper: ' \
          "#{values_lower_bound()} > #{values_upper_bound()}"
      end

      unless (major_ticks_every() % minor_ticks_every()).zero?
        raise 'Major ticks must be a multiple of minor: ' \
          "#{major_ticks_every()} and #{minor_ticks_every()}"
      end

      if values_unit() == Date
        @gmt_offset = values_lower_bound().to_time.gmt_offset
        validate_same_timezone values_upper_bound()
      end

      validate_positioning_arguments
    end

    def validate_same_timezone value
      return if values_unit() != Date
      return if value.to_time.gmt_offset == @gmt_offset

      raise "This value (#{value.inspect}) " \
        "is in a different timezone (#{value.to_time.gmt_offset / 60 / 60})" \
        " than the lower bound (#{@gmt_offset / 60 / 60}). This is likely a bug."
    end

    def validate_positioning_arguments
      legal_combinations = [
        %w[bottom left],
        %w[bottom right],
        %w[top left],
        %w[top right],
        %w[left bottom],
        %w[left top],
        %w[right bottom],
        %w[right top]
      ]
      return if legal_combinations.include? [positioning_axis(), positioning_origin()]

      raise "Invalid positioning combination: axis=#{positioning_axis()} " \
        "origin=#{positioning_origin()}"
    end

    def label_width text
      text.to_s.length * estimated_char_width
    end

    def fix_ambigious_value value
        # Dates are ambiguous because they don't use timezones so convert
        # to something that does.
        value = DateTime.new value.year, value.month, value.day if value.is_a? Date
        value
    end

    # The internal represention that we use for the value may not be the same
    # as what's passed in. Convert.
    def convert_to_internal_value value
      value = fix_ambigious_value value

      if values_unit() == Date
        (BigDecimal(value.to_time.to_i) / SECONDS_PER_DAY) #.to_i
      elsif values_unit == Integer
        value.to_i
      else
        raise "Unexpected unit: #{values_unit()}"
      end
    end

    # Returns an array of these: [px_position, is_major_tick, label]
    def ticks debug=false
      formatter = values_formatter() || ->(value) { value.to_s }
      lower = @values_lower_bound_internal
      upper = @values_upper_bound_internal

      result = []
      offset = lower * minor_ticks_px_between()
      first_tick = lower - (lower % minor_ticks_every())

      tick_count = 0
      if minor_ticks_show_lowest_value() == false && first_tick == lower
        first_tick = lower + minor_ticks_every()
        tick_count = 1
      end

      first_tick.step(upper, minor_ticks_every()) do |tick|
        is_major_tick = (tick % major_ticks_every()).zero? && major_ticks_visible()

        puts "ticks() tick=#{tick}" if debug
        if is_major_tick || minor_ticks_visible()
          display_value = values_lower_bound()
          display_value = display_value.to_date if values_unit() == Date

          result << [
            (tick * minor_ticks_px_between() - offset).to_i,
            is_major_tick,
            formatter.call(display_value + (tick_count * minor_ticks_every()))
          ]
        end
        tick_count += 1
      end
      result
    end

    def to_coordinate_space value:, lower_coordinate:, upper_coordinate:
      value = fix_ambigious_value value
      validate_same_timezone value

      internal_value = convert_to_internal_value value
      puts "to_coordinate_space() value=#{value} internal_value=#{internal_value}"

      value_delta = @values_upper_bound_internal - @values_lower_bound_internal
      value_percent = (internal_value - @values_lower_bound_internal) * 1.0 / value_delta

      coordinate_delta = upper_coordinate - lower_coordinate

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
      # viewport.draw_outline

      if vertical?
        render_vertical viewport
      else
        render_horizontal viewport
      end
    end

    def render_horizontal viewport
      baseline = standard_direction? ? viewport.top : viewport.bottom
      @calculations[:baseline] = baseline

      viewport.canvas.line(
        x1: viewport.left,
        y1: baseline,
        x2: viewport.right,
        y2: baseline,
        style: 'stroke:black;'
      )

      if standard_direction?
        major_tick_edge = baseline + major_ticks_length
        minor_tick_edge = baseline + minor_ticks_length
      else
        major_tick_edge = baseline - major_ticks_length
        minor_tick_edge = baseline - minor_ticks_length
      end

      ticks.each do |x, is_major_tick, label|
        adjusted_x = if coordinate_values_move_in_same_direction_as_data_values?
          x + viewport.left
        else
          viewport.right - x
        end

        # puts "ticks: x=#{x} adjusted_x=#{adjusted_x} left=#{viewport.left}"
        tick_edge = (is_major_tick ? major_tick_edge : minor_tick_edge)
        viewport.canvas.line(
          x1: adjusted_x,
          y1: baseline,
          x2: adjusted_x,
          y2: tick_edge,
          style: 'stroke:black;'
        )
        
        if major_ticks_label_visible() && is_major_tick
          text_baseline = major_tick_edge
          text_baseline += major_ticks_label_font_size_px() if standard_direction?

          @calculations[:tick_label_baseline] = text_baseline
          @calculations[:tick_label_center] = adjusted_x

          viewport.canvas.text(
            label,
            x: adjusted_x,
            y: text_baseline, #major_tick_edge + major_ticks_label_font_size_px(),
            style: "font: italic #{major_ticks_label_font_size_px()}px sans-serif",
            text_anchor: 'middle'
          )
        end
      end

      if label_visible()
        text_baseline = viewport.bottom
        text_baseline = viewport.top + label_font_size_px() unless standard_direction?
        @calculations[:label_baseline] = text_baseline

        viewport.canvas.text(
          label_text(),
          x: viewport.right,
          y: text_baseline, # viewport.bottom - label_font_size_px(),
          style: "font: #{label_font_size_px()}px sans-serif",
          text_anchor: 'end',
          alignment_baseline: 'bottom'
        )
      end
    end

    def preferred_size
      height, width = 0, 0
      if vertical?
        width = major_ticks_length()
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

    def standard_direction?
      %w[bottom left].include? positioning_axis()
    end

    def render_vertical viewport
      top = viewport.top + top_pad

      baseline = standard_direction? ? viewport.right : viewport.left
      @calculations[:baseline] = baseline

      if standard_direction?
        major_tick_edge = baseline - major_ticks_length
        minor_tick_edge = baseline - minor_ticks_length
      else
        major_tick_edge = baseline + major_ticks_length
        minor_tick_edge = baseline + minor_ticks_length
      end
# ----
      viewport.canvas.line(
        x1: baseline,
        y1: top,
        x2: baseline,
        y2: viewport.bottom,
        style: 'stroke:black;'
      )

      ticks.each do |y, is_major_tick, label|
        adjusted_y = if coordinate_values_move_in_same_direction_as_data_values?
          viewport.top + y
        else
          viewport.bottom - y
        end

        viewport.canvas.line(
          x1: (is_major_tick ? major_tick_edge : minor_tick_edge),
          y1: adjusted_y,
          x2: baseline,
          y2: adjusted_y,
          style: 'stroke:black;'
        )
        if major_ticks_label_visible() && is_major_tick
          viewport.canvas.text(
            label,
            x: major_tick_edge,
            y: adjusted_y,
            style: "font: italic #{major_ticks_label_font_size_px}px sans-serif",
            text_anchor: (standard_direction? ? 'end' : 'start'),
            alignment_baseline: 'middle'
          )
          # @calculations[:tick_label_baseline] = major_tick_edge
          # @calculations[:tick_label_center] = adjusted_y
        end
      end

      if label_visible()
        if standard_direction?
          x_rotation = major_tick_edge - label_font_size_px()
          x_rotation -= major_ticks_label_font_size_px() if major_ticks_visible()
        else
          x_rotation = major_tick_edge + label_font_size_px()
          x_rotation += major_ticks_label_font_size_px() if major_ticks_visible()
        end
        y_rotation = top

        viewport.canvas.text(
          label_text(),
          x: x_rotation,
          y: y_rotation,
          style: "font: #{label_font_size_px()}px sans-serif",
          transform: "rotate(270, #{x_rotation}, #{y_rotation})",
          text_anchor: 'end'
        )
        @calculations[:label_baseline] = x_rotation

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
