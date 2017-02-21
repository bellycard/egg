# frozen_string_literal: true
require "shrink"

class DockerCompose
  # Wraps the definition of docker-compose services
  class Service
    include Shrink

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

    def to_yaml
      service_mapping = m([
        yaml_image,
        yaml_dockerfile,
        yaml_command,
        yaml_ports,
        yaml_volumes,
        yaml_links,
        yaml_environment
      ].compact)

      [sc(name), service_mapping]
    end

    def yaml_environment
      [sc("environment"), seq(environment.map { |x| qsc x })] unless environment.empty?
    end

    def yaml_links
      [sc("links"), seq(links.map { |x| qsc x })] unless links.empty?
    end

    def yaml_volumes
      [sc("volumes"), seq(volumes.map { |x| qsc x })] if volumes
    end

    def yaml_ports
      [sc("ports"), seq(ports.map { |x| qsc x })] if ports
    end

    def yaml_command
      [sc("command"), qsc(command)] if command
    end

    def yaml_dockerfile
      [sc("build"), qsc(".")] if dockerfile
    end

    def yaml_image
      [sc("image"), qsc(image)] if image
    end
  end
end
