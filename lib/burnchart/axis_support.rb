module Burnchart

  module AxisSupport

    def label_width
      @options[:value_upper_bound].to_s.length * @options[:estimated_char_width]
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
      minor_ticks_every.step(upper, minor_ticks_every) do |y|
        is_major_tick = (y % major_ticks_every == 0)
        result << [y*px_between_ticks - offset, is_major_tick, y.to_s]
      end
      result
    end
  end
end
