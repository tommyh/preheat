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
end

module ActionController::Caching::Fragments
  # When preheat is enabled, return nil for all fragment reads
  # (to simulate an empty cache)
  def read_fragment_with_stub(*args)
    nil
  end
end

module Preheat
  def self.it
    enable
    result = yield if block_given?
    disable
    result
  end

  def self.enable
    # Force re-caching for Rails.cache.fetch
    ActiveSupport::Cache::Store.class_eval do
      alias_method_chain :fetch, :force
    end
    # Force re-caching for fragment and action caching
    ActionController::Caching::Fragments.class_eval do
      alias_method_chain :read_fragment, :stub
    end
  end

  def self.disable
    ActiveSupport::Cache::Store.class_eval do
      alias_method :fetch, :fetch_without_force
    end
    ActionController::Caching::Fragments.class_eval do
      alias_method :read_fragment, :read_fragment_without_stub
    end
  end
end
