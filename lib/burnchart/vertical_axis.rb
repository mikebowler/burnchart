module Burnchart

  class Size
    attr_accessor :height, :width
    def initialize height:, width:
      @height = height
      @width = width
    end

    def eql? other
      self.height == other.height && self.width == other.width
    end
  end

  class VerticalAxis
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
      }.merge params
    end

  	def render left:, right:, top:, bottom:, canvas:
      canvas.line x1: right, y1: top, x2: right, y2: bottom, style: 'stroke:black;'

      lower = @options[:value_lower_bound]
      upper = @options[:value_upper_bound]
      increment = @options[:px_between_ticks]

      major_tick_left_edge = right - @options[:major_tick_length]
      minor_tick_left_edge = right - @options[:minor_tick_length]

      lower.upto(upper) do |tick_count|
        y = tick_count * increment
        if tick_count % @options[:major_ticks_every] == 0 
          canvas.line x1: major_tick_left_edge, y1: y, x2: right, y2: y, style: 'stroke:black;'
        elsif tick_count % @options[:minor_ticks_every] == 0 
          canvas.line x1: minor_tick_left_edge, y1: y, x2: right, y2: y, style: 'stroke:black;'
        end
      end
  	end

    def preferred_size
      Size.new(
        height: (@options[:value_upper_bound] * @options[:px_between_ticks]).to_i, 
        width: @options[:major_tick_length] + 1
      )
    end

  end
end