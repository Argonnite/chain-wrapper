require_relative '../lib/chainWrapper.rb'
require "awesome_print"

#DEBUG=true
DEBUG=false

chainObj = ChainWrapper.new(3)
chainObj.loadExclusions '../dat/exclusions.dat'
chainObj.addSource '../dat/austen_complete.txt'
#chainObj.addSource '../dat/p_and_p.txt' #pride & prejudice
#chainObj.addSource 'http://www.gutenberg.org/cache/epub/1342/pg1342.txt' #pride & prejudice
#chainObj.addSource 'http://www.gutenberg.org/cache/epub/31100/pg31100.txt' #austen's complete works!

if DEBUG
  ### test file integrity
  chainObj.dumpChain 'jane_chain_1.json'
  chainObj.clearChain
  chainObj.loadChain 'jane_chain_1.json'
  chainObj.dumpChain 'jane_chain_2.json'
  chainObj.dumpStarters 'jane_starters_1.json'
  chainObj.clearStarters
  chainObj.loadStarters 'jane_starters_1.json'
  chainObj.dumpStarters 'jane_starters_2.json'
else
  for i in 1..30
    puts chainObj.generate
  end
end
