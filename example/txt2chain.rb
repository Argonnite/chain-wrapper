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

ngram = ARGV[0]
inFileFn = ARGV[1]
outFileFn = ARGV[2]

if DEBUG
  puts ARGV[0]
  puts ARGV[1]
  puts ARGV[2]
end

chainObj = ChainWrapper.new(ARGV[0].to_i)
chainObj.addSource ARGV[1]
chainObj.dumpChain "#{ARGV[2]}_chain.json"
chainObj.dumpStarters "#{ARGV[2]}_starters.json"

