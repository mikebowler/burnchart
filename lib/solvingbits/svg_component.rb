# frozen_string_literal: true

module SolvingBits
  class SvgComponent
    def preferred_size
      raise 'Should be implemented by subclass'
    end

    def to_svg svg_flavour = :full
      size = preferred_size
      canvas = SvgCanvas.new width: size.width, height: size.height

      render Viewport.new(
        left: 0,
        right: size.width,
        top: 0,
        bottom: size.height,
        canvas: canvas
      )
      canvas.to_svg svg_flavour
    end

    def dump
      puts '      "' + to_svg(:partial).gsub('><', ">\" \\\n      \"<") + '"'
    end
    def dump_to_file filename
      File.open filename, 'w' do |file|
        file.write to_svg(:full)
      end
    end

    def render _viewport
      raise 'Should be implemented by subclass'
    end
  end
end
