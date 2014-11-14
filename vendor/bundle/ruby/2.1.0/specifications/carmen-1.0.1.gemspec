# -*- encoding: utf-8 -*-
# stub: carmen 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "carmen"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jim Benton"]
  s.date = "2014-03-06"
  s.description = "Includes data from the Debian iso-data project."
  s.email = "jim@autonomousmachine.com"
  s.homepage = "http://github.com/jim/carmen"
  s.rubygems_version = "2.2.2"
  s.summary = "A collection of geographic region data for Ruby"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["= 2.6.1"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["= 0.9.2.2"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_runtime_dependency(%q<unicode_utils>, ["~> 1.4.0"])
    else
      s.add_dependency(%q<minitest>, ["= 2.6.1"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<rake>, ["= 0.9.2.2"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<unicode_utils>, ["~> 1.4.0"])
    end
  else
    s.add_dependency(%q<minitest>, ["= 2.6.1"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<rake>, ["= 0.9.2.2"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<unicode_utils>, ["~> 1.4.0"])
  end
end
