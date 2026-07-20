# -*- encoding: utf-8 -*-
# stub: razorpay 3.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "razorpay".freeze
  s.version = "3.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Abhay Rana".freeze, "Harman Singh".freeze]
  s.date = "2026-06-08"
  s.description = "Official ruby bindings for the Razorpay API".freeze
  s.email = ["nemo@razorpay.com".freeze, "harman@razorpay.com".freeze]
  s.homepage = "https://razorpay.com/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Razorpay's Ruby API".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<httparty>.freeze, ["~> 0.14"])
  s.add_development_dependency(%q<coveralls_reborn>.freeze, ["~> 0.8"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.11"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
  s.add_development_dependency(%q<simplecov-cobertura>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.49"])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 3.0"])
end
