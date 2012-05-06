begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError => err
end

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000

require File.expand_path("~/.config.d/ruby/all")
