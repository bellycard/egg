# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "Egg/version"

description = <<-EOT
  Egg helps initialize, manage, and execute on complex multi-service architectures using Docker and Docker Compose
EOT

Gem::Specification.new do |spec|
  spec.name          = "Egg"
  spec.version       = Egg::VERSION
  spec.authors       = ["Carl Thuringer", "Jason Sisk"]
  spec.email         = ["tech@bellycard.com"]

  spec.summary       = "Egg helps you develop with Docker!"
  spec.description   = description
  spec.homepage      = "http://github.com/bellycard/egg"
  spec.license       = "Apache-2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19.4"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", '~> 3.6', '>= 3.6.0'
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2.3"
  spec.add_development_dependency "pronto", "~> 0.9.3"
  spec.add_development_dependency "pronto-rubocop", "~> 0.9.0"
end
