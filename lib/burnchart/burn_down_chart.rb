module Burnchart
  class BurnDownChart
    def to_svg flavour
      canvas = SvgCanvas.new
      canvas.to_svg flavour
    end
  end
end

# x_axis: { label: 'foo', start_date: '', end_date: '', excluded_dates: [] }
# y_axis: { label: 'bar', max_value: 50, show_values: false }
# options: { show_perfect_line: false, heading: 'my data'}
# data_points: []