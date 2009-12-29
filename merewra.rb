#! /usr/bin/env ruby
require "pathname"

class MerewraException < Exception
end

# A feature was tested but found to be not supported by the recoder
class KnownUnsupported < MerewraException
end

class Profile
  def description
    ""
  end
  def acodec
    nil
  end
  def arate
    nil
  end
  def vcodec
    nil
  end
  def width
    nil
  end
  def height
    nil
  end
end

class Backend
  def initialize
    @options = []
  end

  def opts(string)
    @options += string.split
  end

  def run(argv)
    puts "Running #{argv.inspect}"
    system *argv
  end

  def process(profile, in_fname, out_fname)
  end
end

puts "$0 is #{$0}"
libdir = Pathname.new "/home/martin/merewra"
Pathname.glob(libdir + '{backends,profiles}/*.rb') do |r|
  puts "Loading #{r}"
  require r
end

# main

backend_name = ARGV[0]
profile_name = ARGV[1]
in_fname = ARGV[2]
out_fname = ARGV[3]

backend = eval(backend_name.capitalize).new
profile = eval(profile_name.capitalize).new


backend.process(profile, in_fname, out_fname)
