module Burnchart
  class BurnDownChart
    def initialize x_axis: {}, y_axis: {}, options: {}, data_points: []
      @x_axis = {
        day_width: 10,
        start_date: Date.today,
        visible: true
      }.merge x_axis
      
      @y_axis = {
        visible:true,
        point_height: 3,
        max_value: 20
      }.merge y_axis
      
      @options = {
        data_point_radius: 3
      }.merge options

      @data_points = data_points

    end

    def to_svg flavour = :full
      top = 0
      left = 0
      right = 200
      bottom = @y_axis[:max_value] * @y_axis[:point_height]
      canvas = SvgCanvas.new
      # yaxis_width, yaxis_height = draw_yaxis
      # xaxis_width, xaxis_height = draw_xaxis yaxis_width, yaxis_height
      draw_data canvas, left, top, right, bottom
      canvas.to_svg flavour
    end

    def draw_data canvas, left, top, right, bottom
      start_date = @x_axis[:start_date]
      day_width = @x_axis[:day_width]

      points = @data_points.collect do |date, value|
        x = left + ((date-start_date).to_i * day_width) + (day_width/2)
        y = bottom - (value * @y_axis[:point_height])
        [x,y]
      end
      
      last_x, last_y = nil, nil
      points.each do |x,y|
        canvas.line x1: last_x, y1: last_y, x2: x, y2: y, style: 'stroke:red;' unless last_x.nil?
        last_x, last_y = x, y
      end

      points.each do |x,y|
        canvas.circle cx: x, cy: y, r: @options[:data_point_radius], fill: 'red'
      end

    end
  end
end

# x_axis: { label: 'foo', start_date: '', end_date: '', excluded_dates: [] }
# y_axis: { label: 'bar', max_value: 50, show_values: false }
# options: { show_perfect_line: false, heading: 'my data'}
# data_points: []