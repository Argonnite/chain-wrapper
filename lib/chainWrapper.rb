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

require "net/http"
require "awesome_print"
require "mrkv"
require "json"
require "uri"


class ChainWrapper
  attr_accessor :mrkvInst

  ### overrides
  class Mrkv::Chain
    attr_accessor :chain
    attr_accessor :starters
    attr_accessor :ngram
    def add lines
      lines.each do |line|
        line.split.each_cons(@ngram + 1) do |link|
          next if link.nil?
          @chain[link.take(@ngram).join(" ")] << link.last
        end
      end
      @starters = @chain.keys.select{|k| k =~ /^[A-Z]/}
      true
    end
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
        lines << line unless /\(@exclusions\)/i =~ line
      end
      @mrkvInst.add lines
    else #assume file source
      File.foreach(res) do |line|
        lines << line unless /\(#{@exclusions}\)/i =~ line
      end
      @mrkvInst.add lines
    end
  end
  
  ### write internal chain structure to JSON file
  def dumpChain filename
    File.open(filename,"w") do |f|
#      if DEBUG
#        f.puts JSON.pretty_generate(@mrkvInst.chain)
#      else
        f.write(@mrkvInst.ngram)
        f.write(@mrkvInst.chain.to_json)
#      end
      f.close
    end
  end
  
  ### read from JSON file into internal chain structure
  def loadChain filename
    f = File.read(filename)
    @mrkvInst.ngram = f.match(/^\d+/)[0].to_i
    if @mrkvInst.ngram.nil?
      puts "ERROR: ngram absent from file."
      exit
    end
    @mrkvInst.chain = JSON.parse(f.gsub(/^\d+/,''))
    @mrkvInst.starters = @mrkvInst.chain.keys.select{|k| k =~ /^[^A-Z]?[A-Z]/} #bom:utf8
  end
  
  ### reset internal chain structure s
  def clearChain
    @mrkvInst.chain = {}
    @mrkvInst.starters = {}
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
