require 'burnchart/configurable'

module Burnchart
  class AxisSupport
    include Configurable

    attr_configurable :minor_ticks_every, defaults_to: 1
    attr_configurable :minor_tick_length, defaults_to: 10
    attr_configurable :minor_ticks_visible, defaults_to: true
    attr_configurable :major_ticks_every, defaults_to: 1
    attr_configurable :major_tick_length, defaults_to: 7
    attr_configurable :major_ticks_visible, defaults_to: true
    attr_configurable :display_value_for_major_ticks, defaults_to: true
    attr_configurable :px_between_ticks, defaults_to: 5
    attr_configurable :value_lower_bound, defaults_to: 0
    attr_configurable :value_upper_bound, defaults_to: 100
    attr_configurable :value_unit, defaults_to: Integer
    attr_configurable :font_size_px, defaults_to: 13
    attr_configurable :estimated_char_width, defaults_to: 10
    attr_configurable :display_lower_bound_tick, defaults_to: false
    attr_configurable :formatter, defaults_to: 10

    def initialize params = {}
      @options = {
        formatter: lambda do |value|
          if value_unit() == Date
            Date.jd(value).to_s
          else
            value.to_s
          end
        end
      }.merge params

      @options.each_pair do |config, value|
        __send__ "#{config}=", value unless config == :formatter
      end

      if value_unit() == Date
        self.value_lower_bound = self.value_lower_bound.jd
        self.value_upper_bound = self.value_upper_bound.jd
      end

      if value_lower_bound() > value_upper_bound()
        raise "Lower bound must be less than upper: #{value_lower_bound()} > #{value_upper_bound()}"
      end

      unless (major_ticks_every() % minor_ticks_every()).zero?
        raise "Major ticks must be a multiple of minor: #{major_ticks_every()} and #{minor_ticks_every()}"
      end
    end

    def label_width text
      text.to_s.length * estimated_char_width
    end

    # Returns an array of these: [px_position, is_major_tick, label]
    def ticks
      lower = value_lower_bound()
      upper = value_upper_bound()

      result = []
      offset = lower * px_between_ticks()
      first_tick = lower - (lower % minor_ticks_every())
      if display_lower_bound_tick() == false && first_tick == lower
        first_tick = lower + minor_ticks_every()
      end

      first_tick.step(upper, minor_ticks_every()) do |y|
        is_major_tick = (y % major_ticks_every()).zero? && major_ticks_visible()

        next if is_major_tick == false && minor_ticks_visible() == false 

        label = @options[:formatter].call(y)

        result << [y * px_between_ticks() - offset, is_major_tick, label]
      end
      result
    end
  end

  def to_coordinate_space value:, lower_coordinate:, upper_coordinate:
    value = value.jd if value_unit() == Date

    value_delta = value_upper_bound() - value_lower_bound()
    value_percent = (value - value_lower_bound()) * 1.0 / value_delta

    ugly_hack_adjustment = case self
    when VerticalAxis
      -lower_coordinate
    when HorizontalAxis
      lower_coordinate
    else
      raise "Unexpected axis type: #{self.class}"
    end

    coordinate_delta = upper_coordinate - lower_coordinate
    (coordinate_delta * value_percent).to_i + ugly_hack_adjustment
  end
end
