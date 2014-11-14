# -*- encoding: utf-8 -*-
# stub: carmen-rails 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "carmen-rails"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jim Benton"]
  s.date = "2014-03-06"
  s.description = "Provides country_select and subregion_select form helpers."
  s.email = ["jim@autonomousmachine.com"]
  s.homepage = "http://github.com/jim/carmen-rails"
  s.rubygems_version = "2.2.2"
  s.summary = "Rails adapter for Carmen"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 0"])
      s.add_runtime_dependency(%q<carmen>, ["~> 1.0.0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<carmen>, ["~> 1.0.0"])
      s.add_dependency(%q<minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<carmen>, ["~> 1.0.0"])
    s.add_dependency(%q<minitest>, [">= 0"])
  end
end
