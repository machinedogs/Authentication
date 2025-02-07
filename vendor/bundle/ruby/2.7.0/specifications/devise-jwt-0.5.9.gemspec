# -*- encoding: utf-8 -*-
# stub: devise-jwt 0.5.9 ruby lib

Gem::Specification.new do |s|
  s.name = "devise-jwt".freeze
  s.version = "0.5.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marc Busqu\u00E9".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-03-29"
  s.description = "JWT authentication for devise with configurable token revocation strategies".freeze
  s.email = ["marc@lamarciana.com".freeze]
  s.homepage = "https://github.com/waiting-for-dev/devise-jwt".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "JWT authentication for devise".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<devise>.freeze, ["~> 4.0"])
    s.add_runtime_dependency(%q<warden-jwt_auth>.freeze, ["~> 0.3.6"])
    s.add_development_dependency(%q<bundler>.freeze, ["> 1"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
    s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.7"])
    s.add_development_dependency(%q<rails>.freeze, ["~> 5.0"])
    s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3"])
    s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.5"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
    s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0"])
  else
    s.add_dependency(%q<devise>.freeze, ["~> 4.0"])
    s.add_dependency(%q<warden-jwt_auth>.freeze, ["~> 0.3.6"])
    s.add_dependency(%q<bundler>.freeze, ["> 1"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.8"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.7"])
    s.add_dependency(%q<rails>.freeze, ["~> 5.0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.5"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0"])
  end
end
