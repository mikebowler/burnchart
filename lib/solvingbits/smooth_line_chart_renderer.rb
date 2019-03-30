# frozen_string_literal: true

# Algorithm based on this writeup by François Romain
# https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74
module SolvingBits
  class SmoothLineChartRenderer
    attr_accessor :data_points

    def render left:, right:, top:, bottom:, canvas:
      # Without at least two points, there's nothing to draw
      return if @data_points.length < 2

      command = "M#{@data_points[0].x} #{@data_points[0].y}"

      1.upto(@data_points.length - 1) do |i|
        start_control_point = control_point(
          # For the very first point, previous and current are the same
          previous_point: (i > 2 ? @data_points[i - 2] : @data_points[i - 1]),
          current_point: @data_points[i - 1],
          next_point: @data_points[i],
          is_end_control_point: false
        )

        end_control_point = control_point(
          previous_point: @data_points[i - 1],
          current_point: @data_points[i],
          # For the very last point, next and current are the same
          next_point: @data_points[i + 1] || points[i],
          is_end_control_point: true
        )

        command << ' C' << [
          start_control_point.x, start_control_point.y,
          end_control_point.x, end_control_point.y,
          @data_points[i].x, @data_points[i].y
        ].join(' ')
      end

      canvas.path d: command, fill: 'none', stroke: 'red'
    end

    def control_point previous_point:, current_point:, next_point:, is_end_control_point:
      smoothing_ratio = 0.2

      # Properties of the opposed line
      x_length = next_point.x - previous_point.x
      y_length = next_point.y - previous_point.y

      opposed_line_length = Math.sqrt( (x_length ** 2) + (y_length ** 2) )
      opposed_line_angle = Math.atan2 x_length, y_length
      opposed_line_angle += Math::PI if is_end_control_point

      smoothed_length = opposed_line_length * smoothing_ratio

      Point.new(
        x: (current_point.x + Math.cos(opposed_line_angle) * smoothed_length).to_i,
        y: (current_point.y + Math.sin(opposed_line_angle) * smoothed_length).to_i
      )
    end
  end
end
