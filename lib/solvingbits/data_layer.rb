module SolvingBits
  class DataLayer
    def self.create
      instance = new
      yield instance
      instance
    end
  end

  attr_accessor :renderers, :data

  def initialize
    @renderers = []
    @data = []
  end

end