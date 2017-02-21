# frozen_string_literal: true

class DockerCompose
  # Wraps the definition of docker-compose services
  class Service
    attr_reader :name, :links, :environment
    attr_accessor :dockerfile,
                  :command,
                  :ports,
                  :volumes,
                  :image

    def initialize(name)
      @name = name

      @links = []
      @environment = []
    end

    def link(service)
      @links << service.name
    end

    def env(variable, value)
      @environment << "#{variable}=#{value}"
    end

    def to_hash
      output = {
        "environment" => environment,
        "links" => links,
        "volumes" => volumes,
        "ports" => ports
      }

      output["image"] = image if image
      output["build"] = "." if dockerfile
      output["command"] = command if command
      output.compact
    end
  end
end
