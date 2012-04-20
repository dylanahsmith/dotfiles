def ras
  require 'active_support/all'
end

require 'pp'

class << self
  def pp_with_nil_return(*args)
    pp_without_nil_return(*args)
    nil
  end

  alias_method :pp_without_nil_return, :pp
  alias_method :pp, :pp_with_nil_return
end

if defined?(Rails) && !Rails.env.nil? && Rails.logger
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError => err
end

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000

require File.expand_path("~/.config.d/ruby/all")
