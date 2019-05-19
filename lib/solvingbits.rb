# frozen_string_literal: true

# Some files have to be loaded in a specific order so do them first.
preload = %w[configurable svg_component]
preload.each do |file|
  require "solvingbits/#{file}"
end

# Then load the rest
Dir.foreach('lib/solvingbits') do |file|
  next if file.start_with? '.'
  next if preload.include? file

  require "solvingbits/#{file}"
end

module SolvingBits
  class Error < StandardError; end
  # Your code goes here...
end
