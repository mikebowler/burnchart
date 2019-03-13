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
end