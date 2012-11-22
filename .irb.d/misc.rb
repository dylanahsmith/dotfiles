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

if defined?(Rails) && Rails.respond_to?(:env) && !Rails.env.nil? && Rails.logger
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
