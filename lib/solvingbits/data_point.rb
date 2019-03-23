require 'date'

module SolvingBits
  class DataPoint
    attr_reader :date, :value

    def initialize date, value
      if date.is_a? String
        @date = Date.parse date
      else
        @date = date
      end
      @value = value 
    end

    def <=> other
      compare = date <=> other.date
      compare = value <=> other.value if compare == 0
      compare
    end
  end
end