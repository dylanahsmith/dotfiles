#!/usr/bin/env ruby

require 'pathname'
require 'json'

abort("usage: cargo-to DEP_NAME") unless ARGV.size == 1
dep_name = ARGV.first

def find_parent_dir_with(filename, from:)
  dir = from
  until dir.root?
    if dir.join(filename).file?
      return dir
    end
    dir = dir.parent
  end
  nil
end

pwd = Pathname.getwd
if find_parent_dir_with("Cargo.toml", from: pwd)
  metadata = `cargo metadata --format-version=1`
  abort(metadata) unless $?.success?
  metadata_hash = JSON.parse(metadata)
  packages = metadata_hash.fetch('packages')
  package = packages.find { |p| p['name'] == dep_name }
  unless package
    abort "Unable to find dependency '#{dep_name}' locally"
  end
  manifest_path = package.fetch("manifest_path")
  print File.dirname(manifest_path)
else
  dirs = Dir.glob("#{Dir.home}/.cargo/registry/src/index.crates.io-*/#{dep_name}-*")
  if dirs.empty?
    abort "Unable to find crate '#{dep_name}' locally"
  end
  dirs.sort_by! do |d|
    base = File.basename(d)
    version_str = base[dep_name.length + 1..]
    Gem::Version.new(version_str)
  end
  print dirs.last
end
