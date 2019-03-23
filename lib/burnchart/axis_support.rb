require 'burnchart/configurable'

module Burnchart
  class AxisSupport
    include Configurable

    attr_configurable :minor_ticks_every, defaults_to: 1
    attr_configurable :minor_ticks_length, defaults_to: 10
    attr_configurable :minor_ticks_visible, defaults_to: true
    attr_configurable :minor_ticks_px_between, defaults_to: 5

    attr_configurable :major_ticks_every, defaults_to: 1
    attr_configurable :major_ticks_length, defaults_to: 7
    attr_configurable :major_ticks_visible, defaults_to: true
    attr_configurable :major_ticks_show_label, defaults_to: true

    attr_configurable :values_lower_bound, defaults_to: 0
    attr_configurable :values_upper_bound, defaults_to: 100
    attr_configurable :values_unit, defaults_to: Integer
    attr_configurable :font_size_px, defaults_to: 13
    attr_configurable :estimated_char_width, defaults_to: 10
    attr_configurable :display_lower_bound_tick, defaults_to: false
    attr_configurable :formatter, defaults_to: 10

    def initialize params = {}
      @options = {
        formatter: lambda do |value|
          if values_unit() == Date
            Date.jd(value).to_s
          else
            value.to_s
          end
        end
      }.merge params

      @options.each_pair do |config, value|
        next if config == :formatter

        if value.is_a? Hash
          value.each_pair do |key, inner_value|
            method = :"#{config}_#{key}="
            raise "No configuration for #{config}:#{key}" unless respond_to?(method, true)
            __send__ "#{config}_#{key}=", inner_value
          end
        else
            method = :"#{config}="
            raise "No configuration for #{config}" unless respond_to?(method, true)
          __send__ method, value
        end
      end

      if values_unit() == Date
        self.values_lower_bound = self.values_lower_bound.jd
        self.values_upper_bound = self.values_upper_bound.jd
      end

      if values_lower_bound() > values_upper_bound()
        raise "Lower bound must be less than upper: #{values_lower_bound()} > #{values_upper_bound()}"
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
      lower = values_lower_bound()
      upper = values_upper_bound()

      result = []
      offset = lower * minor_ticks_px_between()
      first_tick = lower - (lower % minor_ticks_every())
      if display_lower_bound_tick() == false && first_tick == lower
        first_tick = lower + minor_ticks_every()
      end

      first_tick.step(upper, minor_ticks_every()) do |y|
        is_major_tick = (y % major_ticks_every()).zero? && major_ticks_visible()

        next if is_major_tick == false && minor_ticks_visible() == false 

        label = @options[:formatter].call(y)

        result << [y * minor_ticks_px_between() - offset, is_major_tick, label]
      end
      result
    end
  end

  def to_coordinate_space value:, lower_coordinate:, upper_coordinate:
    value = value.jd if values_unit() == Date

    value_delta = values_upper_bound() - values_lower_bound()
    value_percent = (value - values_lower_bound()) * 1.0 / value_delta

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
