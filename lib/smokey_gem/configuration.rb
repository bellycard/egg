require "yaml"

module SmokeyGem
  class Configuration
    attr_accessor :docker_compose

    def initialize
      @docker_compose = YAML.load(SmokeyGem::Templates["docker-compose.yml"])
      yield self if block_given?
      self
    end

    # Based on rubygems' specification load:
    # https://github.com/rubygems/rubygems/blob/0749715e4bd9e7f0fb631a352ddc649574da91c1/lib/rubygems/specification.rb#L1146
    def self.load(file)
      code = File.read file
      config = eval code, binding, file

      if SmokeyGem::Configuration === config
        return config
      end
    rescue SignalException, SystemExit
      raise
    rescue SyntaxError, Exception => e
      warn "Invalid configuration in [#{file}]: #{e}"
    end
  end
end