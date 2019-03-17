Dir.foreach('lib/burnchart') do |file|
  next if file.start_with? '.'

  require "burnchart/#{file}"
end

module Burnchart
  class Error < StandardError; end
  # Your code goes here...
end
