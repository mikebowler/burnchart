
module Burnchart
  class SmoothLineChartRenderer
    def render canvas, points
      # Without at least two points, there's nothing to draw
      return if points.length < 2

      command = "M#{ points[0].x } #{ points[0].y}"

      1.upto(points.length-1) do |i|
        start_control_point = control_point(
          # For the very first point, previous and current are the same
          previous_point: (i > 2 ? points[i-2] : points[i-1]),
          current_point: points[i-1],
          next_point: points[i],
          is_end_control_point: false
        )

        end_control_point = control_point(
          previous_point: points[i-1],
          current_point: points[i],
          # For the very last point, next and current are the same
          next_point: points[i+1] || points[i],
          is_end_control_point: true
        )

        command << ' C' << [
          start_control_point.x, start_control_point.y,
          end_control_point.x, end_control_point.y,
          points[i].x, points[i].y
        ].join(' ')
      end

      canvas.path d: command, fill: 'none', stroke: 'red'
    end

    def control_point previous_point:, current_point:, next_point:, is_end_control_point:
      smoothing_ratio = 0.2

      # Properties of the opposed line
      lengthX = next_point.x - previous_point.x
      lengthY = next_point.y - previous_point.y

      opposed_line_length - Math.sqrt( (lengthX ** 2) + (lengthY ** 2) )
      opposed_line_angle = Math.atan2 lengthX, lengthY
      opposed_line_angle += Math::PI if is_end_control_point

      smoothed_length - opposed_line_length * smoothing_ratio

      Point.new(
        x: (current_point.x + Math.cos(opposed_line_angle) * smoothed_length).to_i,
        y: (current_point.y + Math.sin(opposed_line_angle) * smoothed_length).to_i
      )
    end
  end
end
