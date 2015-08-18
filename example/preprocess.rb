#Usage: ruby preprocess.rb infile.txt outfile.txt


lines = []
File.foreach(ARGV[0]) do |x|
  lines << x unless x =~ /^#/
end

strings = lines.join
strings = strings.gsub(/Mr\.\s/,'Mr ')
strings = strings.gsub(/Mrs\.\s/,'Mrs ')
strings = strings.gsub(/Ms\.\s/,'Ms ')
strings = strings.gsub(/Dr\.\s/,'Dr ')
strings = strings.gsub(/Drs\.\s/,'Drs ')
strings = strings.gsub(/_/,'') # remove faux italics
strings = strings.gsub(/--/,'') # Ulysses-specific
strings = strings.gsub(/Chapter \w+/i,'')
strings = strings.gsub(/Volume \w+/i,'')
strings = strings.gsub(/[\r\n]+/," ")
strings = strings.gsub(/"/,'')  # strip quotes
strings = strings.gsub(/\(/,'')  # strip left paren
strings = strings.gsub(/\)/,'')  # strip right paren
strings = strings.gsub(/\s{2,}/,' ')  # strip extra space
strings = strings.gsub(/\.\s/,".\n")  # regular period
strings = strings.gsub(/\?\s/,"?\n")  # regular question mark
strings = strings.gsub(/\!\s/,"!\n")  # regular exclamation point
#strings = strings.gsub(/\:\s/,":\n")  # regular colon
strings = strings.gsub(/^\b\w/) { $&.capitalize }

File.open(ARGV[1],'w') { |file| file.write(strings) }


##myAry = strings.split('\n')
##ap myAry
#puts "LINE: #{strings}"
##myAry.each { |line| puts line }
#exit
#      myAry = strings.split('\n')
#      myAry.each do |line|
