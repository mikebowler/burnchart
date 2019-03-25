require 'solvingbits/configurable'

module SolvingBits
  class AbstractAxis
    include Configurable

    attr_configurable :minor_ticks_every, defaults_to: 1
    attr_configurable :minor_ticks_length, defaults_to: 10
    attr_configurable :minor_ticks_visible, defaults_to: true
    attr_configurable :minor_ticks_px_between, defaults_to: 5
    # Often we don't want to display a tick at the 'zero' value
    attr_configurable :minor_ticks_show_lowest_value, defaults_to: false

    attr_configurable :major_ticks_every, defaults_to: 1
    attr_configurable :major_ticks_length, defaults_to: 7
    attr_configurable :major_ticks_visible, defaults_to: true
    attr_configurable :major_ticks_label_visible, defaults_to: true
    attr_configurable :major_ticks_label_font_size_px, defaults_to: 13

    attr_configurable :values_lower_bound, defaults_to: 0
    attr_configurable :values_upper_bound, defaults_to: 100
    attr_configurable :values_unit, defaults_to: Integer
    attr_configurable :values_formatter

    attr_configurable :label_text
    attr_configurable :label_visible, defaults_to: false
    attr_configurable :label_font_size_px, defaults_to: 13

    attr_configurable :estimated_char_width, defaults_to: 10

    def initialize params = {}

      params.each_pair do |config, value|
        if value.is_a? Hash
          value.each_pair do |config2, value2|
            if value2.is_a? Hash
              value2.each do |config3, value3|
                method = :"#{config}_#{config2}_#{config3}="
                raise "No configuration for #{config}::#{config2}::#{config3}" unless respond_to?(method, true)
                __send__ "#{config}_#{config2}_#{config3}=", value3
              end
            else
              method = :"#{config}_#{config2}="
              raise "No configuration for #{config}:#{config2}" unless respond_to?(method, true)
              __send__ "#{config}_#{config2}=", value2
            end
          end
        else
            method = :"#{config}="
            raise "No configuration for #{config}" unless respond_to?(method, true)
          __send__ method, value
        end
      end

      self.values_lower_bound = convert_to_internal_value(self.values_lower_bound)
      self.values_upper_bound = convert_to_internal_value(self.values_upper_bound)

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
      formatter = values_formatter() || lambda {|value| value.to_s}
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
          formatter.call(convert_to_external_value value)
        ]
      end
      result
    end
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
    case self
    when VerticalAxis
      upper_coordinate - ((coordinate_delta - top_pad()) * value_percent).to_i
    when HorizontalAxis
      (coordinate_delta * value_percent).to_i + lower_coordinate
    else
      raise "Unexpected axis type: #{self.class}"
    end
  end
end
