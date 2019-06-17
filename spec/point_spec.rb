# frozen_string_literal: true

require 'spec_helper'

module SolvingBits

  RSpec.describe Point do
    it 'should implement equals' do
      a = Point.new(x: 5, y: 6)
      b = Point.new(x: 5, y: 6)
      expect(a).to eq(b)
    end

    it 'should handle to_s' do
      expect(Point.new(x: 5, y: 6).to_s).to eq('Point(x:5, y:6, metadata:nil)')
    end
  end
end