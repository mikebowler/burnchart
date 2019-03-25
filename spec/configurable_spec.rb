require 'spec_helper'
include SolvingBits

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

  it 'should allow assignment nested argument' do
    object = Class.new do
      include Configurable
      attr_configurable :five
      attr_configurable :one_two_three_four

      def initialize args
        initialize_configuration params: args
      end
    end.new(
      five: 5,
      one: { two: { three: { four: 4 } } }
    )

    expect(object.__send__ :five).to eq(5)
    expect(object.__send__ :one_two_three_four).to eq(4)
  end
end
