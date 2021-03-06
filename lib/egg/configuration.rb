# frozen_string_literal: true

require "yaml"
require "fileutils"
require "dotenv_util"
require "open3"

module Egg
  # Reads and Processes the egg_config.rb file.
  class Configuration
    # Based on rubygems' specification load:
    # https://github.com/rubygems/rubygems/blob/0749715e4bd9e7f0fb631a352ddc649574da91c1/lib/rubygems/specification.rb#L1146
    def self.load(file)
      code = File.read file
      config = eval code, binding, file # rubocop:disable Security/Eval

      return config if config.is_a? Egg::Configuration
    rescue SignalException, SystemExit
      raise
    rescue SyntaxError, StandardError => e
      warn "Invalid configuration in [#{file}]: #{e}"
      warn e.backtrace.join("\n")
    end

    attr_accessor :ssh_support,
                  :supervisor,
                  :dotenv

    def initialize(&configuration_block)
      self.ssh_support = false
      self.dotenv = DotenvUtil.new(File.read(".env.template")) if File.exist?(".env.template")
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

    # You may pass a block to docker_run to read the output in a controlled manner.
    def docker_run(app, command)
      print "docker-compose run #{app} #{command}\n"
      Open3.popen2(%(docker-compose run #{app} #{command})) do |_input, output, wait_thread|
        output_read = output.read
        print output_read + "\n"
        yield output_read if block_given?
        wait_thread.value.success? || raise(StandardError, "docker_run exited with #{wait_thread.value.to_i}")
      end
    end

    def run_setup
      docker_pull_build
      run_after_startup
    end

    def docker_pull_build
      system("docker-compose pull")
      system("docker-compose build") || raise($CHILD_STATUS)
    end

    private

    def run_after_startup
      return unless @after_startup
      print "Running after-startup block\n"
      @after_startup.call
    end
  end
end
