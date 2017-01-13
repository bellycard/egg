# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smokey_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "smokey_gem"
  spec.version       = SmokeyGem::VERSION
  spec.authors       = ["Carl Thuringer"]
  spec.email         = ["carl@bellycard.com"]

  spec.summary       = %q{Smokey helps you develop with Docker}
  spec.description   = %q{Smokey helps initialize, manage, and execute on complex multi-service architectures using Docker and Docker Compose}
  spec.homepage      = "http://github.com/bellycard/smokey_gem"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
