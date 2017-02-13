# frozen_string_literal: true
require "yaml"
require "fileutils"

module SmokeyGem
  # Reads and Processes the smokey_config.rb file.
  class Configuration
    attr_accessor :docker_compose, :ssh_support, :ruby_version, :supervisor

    def initialize
      @docker_compose = DockerCompose.new(
        YAML.load(SmokeyGem::Templates["docker-compose.yml"].result)
      )
      @ssh_support = false
      @ruby_version = "2.4"
      yield self if block_given?
      self
    end

    # Based on rubygems' specification load:
    # https://github.com/rubygems/rubygems/blob/0749715e4bd9e7f0fb631a352ddc649574da91c1/lib/rubygems/specification.rb#L1146
    def self.load(file)
      code = File.read file
      config = eval code, binding, file # rubocop:disable Lint/Eval

      return config if config.is_a? SmokeyGem::Configuration
    rescue SignalException, SystemExit
      raise
    rescue SyntaxError, Exception => e # rubocop:disable Lint/RescueException
      warn "Invalid configuration in [#{file}]: #{e}"
    end

    def run_setup
      dockerfile = Templates["Dockerfile"]
      File.write("Dockerfile", dockerfile.result(binding))

      File.write("docker-compose.yml", docker_compose.to_yaml)
      #
      # dockerignore = Templates[".dockerignore"]
      # File.write(".dockerignore", dockerignore)
      #
      # # 'or fail $?' is an idiom. system calls set $? to the Process Status,
      # so we will raise an exception to that tune.
      # system "eval $(aws --profile smokey ecr get-login)" or fail "#{$?}"
      #
      # # Speed up build by pulling from amazon.
      # system "docker-compose pull" or fail "#{$?}"
      # system "docker-compose build" or fail "#{$?}"
      #
      # FileUtils.cp ".env.template", ".env"
      #
      # system "docker-compose up -d"
      # print "App is now running at http://localhost:3000"
    end
  end
end
