require_relative '../lib/chainWrapper.rb'


chainObj = ChainWrapper.new(3)
chainObj.loadExclusions '../dat/exclusions.dat'
#chainObj.addSource 'http://www.gutenberg.org/cache/epub/1342/pg1342.txt' #pride & prejudice
chainObj.addSource 'http://www.gutenberg.org/cache/epub/31100/pg31100.txt' #austen's complete works!

for i in 1..30
  puts chainObj.generate
end

