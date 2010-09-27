# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{preheat}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Hallett"]
  s.date = %q{2010-09-26}
  s.description = %q{Warm your Rails.cache easier.}
  s.email = %q{tomhallett@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/preheat.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "lib/preheat.rb", "spec/lib/preheat_spec.rb", "preheat.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tommyh/preheat}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Preheat", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{preheat}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Warm your Rails.cache easier.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
