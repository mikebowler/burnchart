module Burnchart
  class SvgCanvas
    def self.svg_primitive name, params
      possible_args = params[:attrs].collect{|a| ":#{a}"}.join(',')
      takes_text = params[:takes_text]
      module_eval <<-END
        def #{name} #{'text,' if takes_text} hash
          possible_args = [#{possible_args}]
          tag = "<#{name}"
          hash.keys.sort{|a,b| possible_args.index(a) <=> possible_args.index(b)}.each do |key|
            tag << " \#{key}='\#{hash[key]}'"
          end
          tag << "#{ takes_text ? ">\#{text}</#{name}>" : "/>" }"

          @svg << tag
        end
      END
    end

    svg_primitive :line, attrs: %w(x1 y1 x2 y2 style)
    svg_primitive :rect, attrs: %w(x y width height stroke_width style)
    svg_primitive :circle, attrs: %w(cx cy r fill)
    svg_primitive :text, attrs: %w(x y), takes_text: true

    def initialize
      @svg = ''
    end

    def to_svg svg_flavour = :full
      output = ''

      if svg_flavour == :full
        output << '<?xml version="1.0" standalone="no"?>' << "\n" <<
          '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' <<
          "\n"
      end

      if svg_flavour == :include_root || svg_flavour == :full
        output << "<svg"
        output << " height='#{@canvas_height}'" if @canvas_height
        output << " width='#{@canvas_width}'>" if @canvas_width
        output << '>'
        output << @svg 
        output << "</svg>"
      elsif svg_flavour == :partial
        output << @svg
      else
        raise "unexpected svg flavour: #{svg_flavour.inspect}"
      end

      output
    end
  end
end

