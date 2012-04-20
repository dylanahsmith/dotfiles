#!/usr/bin/env ruby

unless ARGV.first
  STDERR.puts "Usage: bto GEM_NAME"
  exit
end

def rstrip(str, substr)
  if i = str.rindex(substr)
    str[0..i-1]
  else
    str
  end
end

paths = IO.popen(['bundle', 'list', '--paths']) { |io| io.readlines.map(&:chomp!) }
status=$?

unless status.success?
  STDERR.puts paths
  exit status.exitstatus
end

matches = []
paths.each do |path|
  filename = File.basename path
  libname = rstrip(filename, '-')
  if libname == ARGV.first
    matches = [path]
    break
  elsif filename.start_with?(ARGV.first)
    matches << path
  end
end

if matches.size == 1
  filename, libname = matches.first
  puts "cd #{matches.first.inspect}"
elsif matches.size > 1
  filenames = matches.map { |path| File.basename(path) }
  STDERR.puts "Found #{filenames.size} matching gems:"
  STDERR.puts filenames
  exit 2
else
  STDERR.puts "No \"#{ARGV.first}\" gem found"
  exit 1
end
