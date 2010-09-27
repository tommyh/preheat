class ActiveSupport::Cache::Store

  def fetch_with_force(name, options = {})
    options.merge!({:force => true})
    if block_given?
      fetch_without_force(name, options) do
        yield
      end
    else
      fetch_without_force(name, options)
    end
  end

  #the singleton class_eval workaround for the aliasing is due to this issue:
  # http://newsgroups.derkeiler.com/Archive/Comp/comp.lang.ruby/2006-05/msg00575.html
  def enable_preheat
    (class << self; self; end).class_eval { alias_method_chain :fetch, :force }
  end

  def disable_preheat
    (class << self; self; end).class_eval { alias_method :fetch, :fetch_without_force }
  end
end

module Preheat
  def self.it
    RAILS_CACHE.enable_preheat
    yield if block_given?
    RAILS_CACHE.disable_preheat
  end
end
