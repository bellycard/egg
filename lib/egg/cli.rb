# frozen_string_literal: true

require "thor"
require "fileutils"

module Egg
  # Defines the CLI interface to egg functions
  class CLI < Thor
    desc "init", "Initialize the current directory as a egg repo."
    option :force
    def init
      config = Templates["egg_config.rb"]
      if File.exist?("egg_config.rb") && !options[:force]
        print "egg has already been initialized! (maybe you want to --force)\n"
        exit(1)
      else
        File.write("egg_config.rb", config.result)
        print "Wrote example egg_config.rb, customize it to suit your app"
        write_git_ignorance
      end
    end

    desc "readme", "Display readme for egg apps."
    def readme
      # Print out the readme
      readme_path = File.expand_path("../../../doc/README.md", __FILE__)
      File.open(readme_path, "r") do |f|
        print(f.read)
      end
    end

    desc "setup", "Run all setup"
    def setup
      config = Configuration.load "./egg_config.rb"
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
