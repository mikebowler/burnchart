module Burnchart

  module AxisSupport
    def initialize params = {}
      @options = {
        minor_ticks_every: 1,
        minor_tick_length: 3,
        major_ticks_every: 10,
        major_tick_length: 7,
        display_value_for_major_ticks: true,
        px_between_ticks: 5,
        value_lower_bound: 0,
        value_upper_bound: 100,
        value_unit: Integer,
        font_size_px: 13,
        estimated_char_width: 10,
        formatter: lambda do |value|
          if @options[:value_unit] == Date
            Date.jd(value).to_s
          else
            value.to_s
          end
        end
      }.merge params

      if @options[:value_unit] == Date
        @options[:value_lower_bound] = @options[:value_lower_bound].jd
        @options[:value_upper_bound] = @options[:value_upper_bound].jd
      end

      if @options[:value_lower_bound] > @options[:value_upper_bound]
        raise "Lower bound must be less than upper: #{@options[:value_lower_bound]} > #{@options[:value_upper_bound]}"
      end

      unless @options[:major_ticks_every] % @options[:minor_ticks_every] == 0
        raise "Major ticks must be a multiple of minor: #{@options[:major_ticks_every]} and #{@options[:minor_ticks_every]}"
      end
    end

    def label_width text
      text.to_s.length * @options[:estimated_char_width]
    end

    # Returns an array of these: [px_position, is_major_tick, label]
    def ticks
      minor_ticks_every = @options[:minor_ticks_every]
      major_ticks_every = @options[:major_ticks_every]
      px_between_ticks = @options[:px_between_ticks]
      lower = @options[:value_lower_bound]
      upper = @options[:value_upper_bound]
      px_between_ticks = @options[:px_between_ticks]

      result = []
      offset = lower * px_between_ticks
      first_tick = lower - (lower % minor_ticks_every)
      first_tick = lower + minor_ticks_every if first_tick == lower

      first_tick.step(upper, minor_ticks_every) do |y|
        is_major_tick = (y % major_ticks_every == 0)
        label = @options[:formatter].call(y)

        result << [y*px_between_ticks - offset, is_major_tick, label]
      end
      result
    end
  end
end
