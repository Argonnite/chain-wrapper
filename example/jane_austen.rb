require_relative '../lib/chainWrapper.rb'


chainObj = ChainWrapper.new(3)
chainObj.loadExclusions '../dat/exclusions.dat'
#chainObj.addSource 'http://www.gutenberg.org/cache/epub/1342/pg1342.txt' #pride & prejudice
chainObj.addSource 'http://www.gutenberg.org/cache/epub/31100/pg31100.txt' #austen's complete works!
chainObj.addSource '../dat/sayings.dat'  #add some non-jane sayings
#chainObj.dumpChain 'blah.json'
#chainObj.clearChain
#chainObj.loadChain 'blah.json'
for i in 1..10
  puts chainObj.generate
end

