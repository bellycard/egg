# frozen_string_literal: true
require "thor"
require "fileutils"

module SmokeyGem
  # Defines the CLI interface to smokey functions
  class CLI < Thor
    desc "init", "Initialize the current directory as a Smokey repo."
    option :force
    def init
      config = Templates["smokey_config.rb"]
      if File.exist?("smokey_config.rb") && !options[:force]
        print "Smokey has already been initialized! (maybe you want to --force)\n"
        exit(1)
      else
        File.write("smokey_config.rb", config.result)
        write_git_ignorance
      end
    end

    desc "readme", "Display readme for Smokey apps."
    def readme
      # Print out the readme
      File.open("doc/README.md", "r") do |f|
        print(f.read)
      end
    end

    desc "setup", "Run all setup"
    def setup
      config = Configuration.load "./smokey_config.rb"
      config.run_setup
    end

    private

    def write_git_ignorance
      gitignore = File.read(".gitignore")
      gitignore << "Dockerfile\n" unless /^Dockerfile$/ =~ gitignore
      gitignore << ".dockerignore\n" unless /^\.dockerignore$/ =~ gitignore
      gitignore << "docker-compose.yml\n" unless /^docker-compose\.yml$/ =~ gitignore
      File.write(".gitignore", gitignore)
    end
  end
end
