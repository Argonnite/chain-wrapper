require_relative '../lib/chainWrapper.rb'
require "awesome_print"

chainObj = ChainWrapper.new # ngram is loaded from file.
chainObj.loadChain ARGV[0]
puts chainObj.generate
