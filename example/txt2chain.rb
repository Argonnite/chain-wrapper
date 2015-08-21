#Usage:  ruby txt2chain.rb <ngram> <inputTxtFileName> <outputFileStem>
#Example:  ruby txt2chain.rb 2 ../dat/preprocessed_austen.txt ../output/austen_ngram2
#Produces: ../output/austen_ngram2_chain.json and ../output/austen_ngram2_starters.json

require_relative '../lib/chainWrapper.rb'
require "awesome_print"

#DEBUG=true
DEBUG=false

if ARGV.size != 3
  puts "NOPE!"
  exit
end

if DEBUG
  puts ARGV[0] #ngram
  puts ARGV[1] #input text filename
  puts ARGV[2] #output json filename
end

chainObj = ChainWrapper.new(ARGV[0].to_i)
chainObj.addSource ARGV[1]
chainObj.dumpChain ARGV[2]

