# chainWrapper.rb -- an OO wrapper around MRKV ruby gem
#    Copyright (C) 2015  Geroncio Galicia
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'net/http'
require "awesome_print"
require "mrkv"
require "json"
require "uri"


class ChainWrapper

  ### override
  class Mrkv::Chain
    attr_accessor :chain
    attr_accessor :starters
  end

  ### non-negative integer
  attr_accessor :ngram
  
  ### ignore input lines containing these words (e.g. hashtags, twitter mentions, gutenberg, ebook, etc.)
  attr_accessor :exclusions
  
  def initialize ngram=2
    @mrkvInst = Mrkv::Chain.new(ngram) # ngram defaults to 2
    @exclusions = '(?!)'  # default to "doesn't match anything"
  end
  
  ### insert source text into internal chain using current ngram setting
  def addSource res
    lines = []
    if /\A#{URI::regexp(['http', 'https'])}\z/ =~ res #assume webpage
      uri = URI(res)
      @source = Net::HTTP.get(uri.host,uri.path)
      @source.split(/[^a-zA-Z0-9\.\!\?\s]/).each do |line|
        lines << line unless /#{@exclusions}/i =~ line
      end
      @mrkvInst.add lines
    else #assume file source
      File.foreach(res) {|x| lines << x}
      @mrkvInst.add lines
    end
  end
  
  ### write internal chain structure to JSON file
  def dumpChain filename
    File.open(filename,"w") do |f|
      if DEBUG
        f.puts JSON.pretty_generate(@mrkvInst.chain)
      else
        f.write(@mrkvInst.chain.to_json)
      end
      f.close
    end
  end
  
  ### read from JSON file into internal chain structure
  def loadChain filename
    @mrkvInst.chain = JSON.parse(File.read(filename))
  end
  
  ### reset internal chain structure 
  def clearChain
    @mrkvInst.chain = {}
  end

  ### write internal starters structure to JSON file
  def dumpStarters filename
    File.open(filename,"w") do |f|
      if DEBUG
        f.puts(JSON.pretty_generate(@mrkvInst.starters))
      else
        f.write(@mrkvInst.starters.to_json)
      end
      f.close
    end
  end
  
  ### load starters from JSON
  def loadStarters filename
    @mrkvInst.starters = JSON.parse(File.read(filename))
  end

  ### reset internal starters
  def clearStarters
    @mrkvInst.chain = {}
  end


#  def addExclusion singleLine
#  end
#
#  def dumpExclusions filename
#  end

  def loadExclusions filename
    @exclusions = []
    File.foreach(filename) {|x| @exclusions << x.chomp}
    @exclusions = @exclusions.join("|") #readify for an "or" regexp
  end

#  def clearExclusions
#  end

  def generate
    @mrkvInst.generate
  end
end
