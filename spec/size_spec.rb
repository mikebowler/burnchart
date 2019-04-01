# frozen_string_literal: true

require 'spec_helper'
include SolvingBits

RSpec.describe Point do
  it 'should implement equals' do
    a = Size.new(height: 1, width: 3)
    b = Size.new(height: 1, width: 3)

    expect(a).to eq(b)
  end

  it 'should handle to_s' do
    expect(Size.new(height: 5, width: 6).to_s).to eq('Size(height:5,width:6)')
  end
end