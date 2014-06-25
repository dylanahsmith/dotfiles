#!/usr/bin/env RBENV_VERSION=system ruby

# cd using a project configurable CDPATH.

# 1. Add the following function to .bashrc
#
# to() { eval "$(to.rb "$@")"; }
#
# 2. Create a base .to-dirs list of directories
#    that will always be at the end of the CDPATH
#
# $ cat >> ~/.to-dirs <<EOF
# src
# .
# EOF
#
# 3. Create project specific lists of directories
#    for the start of the CDPATH when `to` is used
#    within that project.
#
# $ cat >> ~/src/railsapp/.to-dirs <<EOF
# .
# app
# public
# lib
# vendor
# vendor/plugins
# db
# app/assets
# EOF
#
# 4. Jump around
#
# ~$ to railsapp
# ~/src/railsapp$ to controllers
# ~/src/railsapp/app/controllers$ to Desktop
# ~/Desktop$ to railsapp migrate
# ~/src/railsapp/db/migrate$ to
# ~/src/railsapp$ to ruby
# ~/src/ruby$

require 'pathname'
require 'optparse'

USAGE = "to [DIR...]"
HOMEDIR = Dir.respond_to?(:home) ? Dir.home : ENV["HOME"]

def dirs_from_config(dir)
  paths = dir.join('.to-dirs').readlines
  paths.map { |p| dir.join(p.strip) }
end

def to_dirs
  default_dir=nil

  config_dirs = []

  home_path = Pathname.new(HOMEDIR)

  dir = Pathname.pwd
  until dir.root?
    if dir != home_path && dir.join('.to-dirs').file?
      default_dir ||= dir
      config_dirs += dirs_from_config(dir)
    end
    dir = dir.parent
  end
  config_dirs += dirs_from_config(home_path) if home_path.join('.to-dirs').file?
  default_dir ||= home_path
  [config_dirs, default_dir]
end

def find_dir(dir)
  config_dirs, default_dir = to_dirs
  return default_dir unless dir
  config_dirs.each do |path|
    if (absdir = path.join(dir)).directory?
      Dir.chdir absdir
      return absdir
    end
  end
  nil
end

def jump_to(dir, &block)
  if found_dir = find_dir(dir)
    Dir.chdir(found_dir, &block)
    return found_dir
  else
    nil
  end
end

help = false
complete = false

OptionParser.new do |opts|
  opts.banner = USAGE
  opts.on('--complete') { complete = true }
  opts.on('-h', '--help') { $stderr.puts opts and exit }
end.parse!

final_dir = ARGV.pop
ARGV.each do |dir|
  unless jump_to dir
    break if complete
    abort "to: #{dir}: No such directory on search path"
  end
end

if complete
  compword = final_dir
  pattern = compword
  pattern += '*' unless pattern.end_with?('*')
  pattern += '/' unless pattern.end_with?('/')

  candidates = []
  to_dirs.first.each do |path|
    next unless path.directory?
    Dir.chdir(path) do
      candidates += Dir.glob(pattern)
    end
  end
  if candidates.size == 1
    jump_to(candidates.first) do
      candidates += Dir.glob('*/').map{ |d| candidates.first + d }
    end
  end
  puts candidates
  exit
end

if found_dir = find_dir(final_dir)
  puts "cd #{found_dir.expand_path.to_s.inspect}"
else
  abort "to: #{final_dir}: No such directory on search path"
end
