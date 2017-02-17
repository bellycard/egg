# frozen_string_literal: true
require "yaml"
require "fileutils"
require "dotenv_util"

module SmokeyGem
  # Reads and Processes the smokey_config.rb file.
  class Configuration
    # Based on rubygems' specification load:
    # https://github.com/rubygems/rubygems/blob/0749715e4bd9e7f0fb631a352ddc649574da91c1/lib/rubygems/specification.rb#L1146
    def self.load(file)
      code = File.read file
      config = eval code, binding, file # rubocop:disable Security/Eval

      return config if config.is_a? SmokeyGem::Configuration
    rescue SignalException, SystemExit
      raise
    rescue SyntaxError, Exception => e # rubocop:disable Lint/RescueException
      warn "Invalid configuration in [#{file}]: #{e}"
    end

    attr_accessor :docker_compose,
                  :ssh_support,
                  :ruby_version,
                  :supervisor,
                  :database_url

    def initialize(&configuration_block)
      self.docker_compose = DockerCompose.new(
        YAML.safe_load(SmokeyGem::Templates["docker-compose.yml"].result)
      )
      self.ssh_support = false
      self.ruby_version = "2.4"
      instance_eval(&configuration_block)
      self
    end

    def run_setup
      write_templates

      # # 'or fail $?' is an idiom. system calls set $? to the Process Status,
      # so we will raise an exception to that tune.
      # system "eval $(aws --profile smokey ecr get-login)" or fail "#{$?}"
      #
      # # Speed up build by pulling from amazon.
      system "docker-compose pull"
      system "docker-compose build" or raise $CHILD_STATUS # rubocop:disable Style/AndOr

      File.open(".env.template", "r") do |dotenv_file|
        util = DotenvUtil.new(dotenv_file)
        util.set("DATABASE_URL", database_url) if database_url
        File.write(".env", util.generate_env.read)
      end

      system "docker-compose up -d"
      print "App is now running at http://localhost:3000"
    end

    private

    def write_templates
      dockerfile = Templates["Dockerfile"]
      File.write("Dockerfile", dockerfile.result(binding))

      File.write("docker-compose.yml", docker_compose.to_yaml)

      dockerignore = Templates[".dockerignore"]
      File.write(".dockerignore", dockerignore)
    end
  end
end
