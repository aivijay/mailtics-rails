#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

options = OpenStruct.new
options.rows = 100
#options.columns = 10
OptionParser.new do |opts|
  opts.on('-r', '--rows [INTEGER]', 'Number of rows', Integer) do |x|
    options.rows = x
  end
#  opts.on('-c', '--columns [INTEGER]', 'Number of columns', Integer) do |x|
#    options.columns = x
#  end
end.parse!

require 'rubygems'
require 'fastercsv'
require 'webster'

webster = Webster.new

ARGV << '/dev/stdout' if ARGV.empty?
ARGV.each do |file_name|
  file = File.new(file_name, "w+")
  options.rows.times do |row_index|
    ri = row_index.to_s
    data = 'email' + ri + '@mailtics.com,First Name ' + ri + ', Last Name '+ ri
    file.puts data 
  end
end
