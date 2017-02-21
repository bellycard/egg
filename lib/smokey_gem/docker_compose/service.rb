# frozen_string_literal: true
require "shrink"

class DockerCompose
  # Wraps the definition of docker-compose services
  class Service
    include Shrink

    attr_accessor :name,
                  :dockerfile,
                  :command,
                  :ports,
                  :volumes

    def initialize(name, dockerfile: nil, command: nil, ports: nil, volumes: nil)
      self.name = name
      self.dockerfile = dockerfile
      self.command = command
      self.ports = ports
      self.volumes = volumes
    end

    def to_yaml
      service_mapping = m

      service_mapping.children.concat [sc("build"), qsc(".")] if dockerfile
      service_mapping.children.concat [sc("command"), qsc(command)] if command
      service_mapping.children.concat [sc("ports"), seq(ports.map { |x| qsc x })] if ports
      service_mapping.children.concat [sc("volumes"), seq(volumes.map { |x| qsc x })] if volumes

      [sc(name), service_mapping]
    end
  end
end
