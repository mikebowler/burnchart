Dir.foreach('lib/solvingbits') do |file|
  next if file.start_with? '.'

  require "solvingbits/#{file}"
end

module SolvingBits
  class Error < StandardError; end
  # Your code goes here...
end
