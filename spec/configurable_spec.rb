require 'spec_helper'
include Burnchart

RSpec.describe Configurable do
  it 'should allow simple argument' do
    object = Class.new do
      include Configurable
      attr_configurable :one
    end.new

    expect(object.__send__ :one).to be_nil
    object.__send__ :one=, 2
    expect(object.__send__ :one).to eq(2)
  end

  it 'should allow default value' do
    object = Class.new do
      include Configurable
      attr_configurable :one, defaults_to: 1
    end.new

    expect(object.__send__ :one).to eq(1)
  end
end
