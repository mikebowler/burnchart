# frozen_string_literal: true

module SolvingBits
  class DataLayer
    def self.create
      instance = new
      yield instance
      instance
    end

    attr_accessor :renderers, :data

    def initialize
      @renderers = []
      @data = []
    end
  end
end
