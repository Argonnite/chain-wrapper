require_relative '../lib/chainWrapper.rb'

### debugging using a smaller chain; that Austen sure is verbose

#DEBUG=true
DEBUG=false

chainObj = ChainWrapper.new(1)

chainObj.addSource '../dat/sayings.dat'
#chainObj.addSource '../dat/hamlet_soliloquy_2.dat'

if DEBUG
  ### test file integrity
  chainObj.dumpChain 'snark_chain_1.json'
  chainObj.clearChain
  chainObj.loadChain 'snark_chain_1.json'
  chainObj.dumpChain 'snark_chain_2.json'
  chainObj.dumpStarters 'snark_starters_1.json'
  chainObj.clearStarters
  chainObj.loadStarters 'snark_starters_1.json'
  chainObj.dumpStarters 'snark_starters_2.json'
else
  for i in 1..30
    puts chainObj.generate
  end
end
