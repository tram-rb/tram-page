# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tram/page/version"

Gem::Specification.new do |spec|
  spec.name          = "tram-page"
  spec.version       = Tram::Page::VERSION
  spec.authors       = ["Viktor Sokolov"]
  spec.email         = ["gzigzigzeo@gmail.com"]

  spec.summary       = %(Page Object pattern)
  spec.description   = %(Page Object pattern)
  spec.homepage      = "https://github.com/tram-rb/tram-page"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"

  spec.add_dependency "dry-initializer"
end
