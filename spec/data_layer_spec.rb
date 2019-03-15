module Burnchart

  class DataLayer
    @attr_accessor :data, :title
    @attr_reader   :renderers

    def initialize
      @renderers = []
    end

    def render left:, right:, top:, bottom:, canvas:, x_axis:, y_axis:
    end

  end
end