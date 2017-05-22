# frozen_string_literal: true

require "yaml"
require "fileutils"
require "dotenv_util"
require "dockerfile"
require "open3"

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
    rescue SyntaxError, StandardError => e
      warn "Invalid configuration in [#{file}]: #{e}"
      warn e.backtrace.join("\n")
    end

    attr_accessor :docker_compose,
                  :ssh_support,
                  :ruby_version,
                  :supervisor,
                  :dotenv,
                  :dockerfile

    def initialize(&configuration_block)
      self.docker_compose = DockerCompose.new
      self.ssh_support = false
      self.ruby_version = "2.4"
      self.dotenv = DotenvUtil.new(File.read(".env.template"))
      instance_eval(&configuration_block)
      self
    end

    def after_startup(&block)
      @after_startup = block
    end

    # You may pass a block to docker_exec to read the output in a controlled manner.
    def docker_exec(app, command)
      print "docker-compose exec #{app} #{command}\n"
      Open3.popen2(%(docker-compose exec #{app} #{command})) do |_input, output, wait_thread|
        output_read = output.read
        print output_read + "\n"
        yield output_read if block_given?
        wait_thread.value.success? || raise(StandardError, "docker_exec exited with #{wait_thread.value.to_i}")
      end
    end

    def run_setup
      write_docker_files

      docker_pull_build
      File.write(".env", dotenv.generate_env)
      system("docker-compose up -d")

      run_after_startup

      print "App is now running at http://localhost:#{app_port}\n"
    end

    def app_port
      docker_compose.services.find { |s| s.name == "app" }.ports[0].split(":")[0]
    end

    private

    def run_after_startup
      return unless @after_startup
      print "Running after-startup block\n"
      @after_startup.call
    end

    def docker_pull_build
      system("docker-compose pull")
      system("docker-compose build") || raise($CHILD_STATUS)
    end

    def write_docker_files
      File.write("Dockerfile", dockerfile.render) if defined?('dockerfile')

      dockerignore = Templates[".dockerignore"].result(binding)
      File.write(".dockerignore", dockerignore)

      File.write("docker-compose.yml", docker_compose.to_yaml)
    end
  end
end
