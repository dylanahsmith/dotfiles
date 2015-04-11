def ras
  require 'active_support/all'
end

def print_filter_stack(controller)
  puts controller._process_action_callbacks.map(&:filter)
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
