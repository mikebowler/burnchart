module Burnchart

  class Size
    attr_accessor :height, :width
    def initialize height:, width:
      @height = height
      @width = width
    end

    def == other
      self.height == other.height && self.width == other.width
    end

    def to_s
      "Size(height:#{@height},width:#{@width})"
    end
  end
end