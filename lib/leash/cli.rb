# frozen_string_literal: true

require "thor"
require "fileutils"

module Leash
  # Defines the CLI interface to leash functions
  class CLI < Thor
    desc "init", "Initialize the current directory as a Leash repo."
    option :force
    def init
      config = Templates["leash_config.rb"]
      if File.exist?("leash_config.rb") && !options[:force]
        print "Leash has already been initialized! (maybe you want to --force)\n"
        exit(1)
      else
        File.write("leash_config.rb", config.result)
        print "Wrote example leash_config.rb, customize it to suit your app"
        write_git_ignorance
      end
    end

    desc "readme", "Display readme for Leash apps."
    def readme
      # Print out the readme
      readme_path = File.expand_path("../../../doc/README.md", __FILE__)
      File.open(readme_path, "r") do |f|
        print(f.read)
      end
    end

    desc "setup", "Run all setup"
    def setup
      config = Configuration.load "./leash_config.rb"
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
