require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "preheat"
    gemspec.summary = "Keep your Rails.cache warm"
    gemspec.description = "Keep your Rails.cache warm"
    gemspec.email = "tomhallett@gmail.com"
    gemspec.homepage = "http://github.com/tommyh/preheat"
    gemspec.authors = ["Tom Hallett"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
