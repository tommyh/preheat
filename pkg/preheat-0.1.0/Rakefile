require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('preheat', '0.1.0') do |p|
  p.description    = "Warm your Rails.cache easier."
  p.url            = "http://github.com/tommyh/preheat"
  p.author         = "Tom Hallett"
  p.email          = "tomhallett@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each 
