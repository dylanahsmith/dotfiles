#!/usr/bin/env ruby

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
# ~/src/railsapp/app/controllers$ to migrate
# ~/src/railsapp/db/migrate$ to
# ~/src/railsapp$ to Desktop
# ~/Desktop$ to ruby
# ~/src/ruby$

require 'pathname'

def dirs_from_config(dir)
  paths = dir.join('.to-dirs').readlines
  paths.map { |p| dir.join(p.strip) }
end

default_dir=nil

configdirs = []

homedir = Pathname.new(ENV['HOME'])
configdirs += dirs_from_config(homedir) if homedir.join('.to-dirs').file?

dir = Pathname.pwd
until dir.root?
  if dir != homedir && dir.join('.to-dirs').file?
    default_dir ||= dir
    configdirs += dirs_from_config(dir)
  end
  dir = dir.parent
end

cdpath = configdirs.join(':')
args = ARGV.map(&:inspect).join(' ')

if ARGV.first
  puts "CDPATH=#{cdpath.inspect} cd -P #{args}"
else
  puts "cd #{default_dir.to_s.inspect}"
end
