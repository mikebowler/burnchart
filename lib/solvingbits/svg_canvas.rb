# frozen_string_literal: true

module SolvingBits
  class SvgCanvas
    attr_accessor :canvas_height, :canvas_width

    def self.svg_primitive name, params
      possible_args = params[:attrs].collect { |a| ":#{a}" }.join(',')
      takes_text = params[:takes_text]

      module_eval <<-PRIMITIVE, __FILE__, __LINE__ + 1
      # puts <<-PRIMITIVE
        def #{name} text=nil, hash={}
          if text.is_a? Hash
            hash = text
            text = nil
          end

          possible_args = [#{possible_args}]
          hash.keys.each do |key|
            raise "\#{key} is not an attribute on svg #{name}" unless possible_args.include? key
          end
          tag = "<#{name}"
          hash.keys.sort{|a,b| possible_args.index(a) <=> possible_args.index(b)}.each do |key|
            tag << " \#{key.to_s.gsub('_','-')}='\#{hash[key]}'"
          end

          if text
            tag << ">" << text << "</#{name}>"
          elsif block_given?
            tag << '>'
            @svg << tag
            yield
            @svg << "</#{name}>"
            tag = nil
          else
            tag << '/>'
          end

          @svg << tag unless tag.nil?
        end
      PRIMITIVE
    end

    svg_primitive :line, attrs: %w[x1 y1 x2 y2 style]
    svg_primitive :rect, attrs: %w[x y width height style]
    svg_primitive :circle, attrs: %w[cx cy r fill]
    svg_primitive :path, attrs: %w[d fill stroke]
    svg_primitive :text, attrs: %w[x y style text_anchor transform alignment_baseline dominant_baseline]
    svg_primitive :tspan, attrs: %w[alignment_baseline dominant_baseline]
    svg_primitive :title, attrs: %w[style]

    def initialize width: nil, height: nil
      @svg = +''
      @canvas_height = height
      @canvas_width = width
    end

    def to_svg svg_flavour = :full
      output = +''

      if svg_flavour == :full
        output << "<?xml version=\"1.0\" standalone=\"no\"?>\n" \
          '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" ' \
          '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' \
          "\n"
      end

      if [:include_root, :full].include? svg_flavour
        output << '<svg'
        output << " height='#{@canvas_height}'" if @canvas_height
        output << " width='#{@canvas_width}'" if @canvas_width
        output << ' xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"'
        output << '>'
        output << @svg
        output << '</svg>'
      elsif svg_flavour == :partial
        output << @svg
      else
        raise "unexpected svg flavour: #{svg_flavour.inspect}"
      end

      output
    end

    # Method to conveniently dump out the string we need to paste into the test
    def dump
      puts '      "' + to_svg(:partial).gsub('><', ">\" \\\n      \"<") + '"'
    end
  end
end

