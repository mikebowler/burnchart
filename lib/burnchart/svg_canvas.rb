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
      if svg_flavour == :full
        '<?xml version="1.0" standalone="no"?>' << "\n" <<
        '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' <<
        "\n<svg>" <<
        @svg << "</svg>"
      elsif svg_flavour == :partial
        @svg
      else
        raise "unexpected svg flavour: #{svg_flavour}"
      end
    end
  end
end




# <svg width="995" height="185"

#  xmlns="http://www.w3.org/2000/svg"

#  xmlns:xlink="http://www.w3.org/1999/xlink">



# <style type="text/css">

# <![CDATA[

#  text {

#    fill: black;

#    font: italic 13px sans-serif;

#  }

# ]]>

# </style>



# <line x1="0" y1="149" x2="975" y2="149" stroke="gray"/>
#       @svg
#     end
#   end
# end