# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "smokey_gem/version"

description = <<-EOT
Smokey helps initialize, manage, and execute on complex multi-service architectures using Docker and Docker Compose
EOT

Gem::Specification.new do |spec|
  spec.name          = "smokey_gem"
  spec.version       = SmokeyGem::VERSION
  spec.authors       = ["Carl Thuringer"]
  spec.email         = ["carl@bellycard.com"]

  spec.summary       = "Smokey helps you develop with Docker"
  spec.description   = description
  spec.homepage      = "http://github.com/bellycard/smokey_gem"
  spec.license       = "Apache-2.0"
  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19.4"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.46.0"
end
