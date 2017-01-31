require "thor"
require "fileutils"

module SmokeyGem
  # Defines the CLI interface to smokey functions
  class CLI < Thor
    desc "init", "Initialize the current directory as a Smokey repo."
    def init
      config = Configuration.load "./smokey_config.rb"

      FileUtils.mkpath(%w(smokey setup))

      dockerfile = Templates["Dockerfile"]
      File.write("Dockerfile", dockerfile)

      File.write("docker-compose.yml", DockerCompose.new(config.docker_compose).to_yaml)

      smokey_setup = Templates["smokey_setup"]
      File.write("smokey/setup", smokey_setup)
      FileUtils.chmod("+x", "smokey/setup")

      dockerignore = Templates[".dockerignore"]
      File.write(".dockerignore", dockerignore)
      # Write template out for Dockerfile
      # Create smokey directory
      # Write template out for setup script
    end

    desc "readme", "Display readme for Smokey apps."
    def readme
      # Print out the readme
      File.open("doc/README.md", "r") do |f|
        print(f.read)
      end
    end

    desc "setup", "Run the setup script."
    def setup
      system "smokey/setup" or fail "#{$?}"
    end
  end
end
