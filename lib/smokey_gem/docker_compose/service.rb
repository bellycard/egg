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
                  :volumes,
                  :links,
                  :image,
                  :environment

    def initialize(name,
                   dockerfile: nil,
                   command: nil,
                   ports: nil,
                   volumes: nil,
                   image: nil)
      self.name = name
      self.dockerfile = dockerfile
      self.command = command
      self.ports = ports
      self.volumes = volumes
      self.image = image
      self.links = []
      self.environment = []
    end

    def link(service)
      links << service.name
    end

    def env(variable, value)
      environment << "#{variable}=#{value}"
    end

    def to_yaml # rubocop:disable Metrics/AbcSize
      service_mapping = m

      service_mapping.children.concat [sc("image"), qsc(image)] if image
      service_mapping.children.concat [sc("build"), qsc(".")] if dockerfile
      service_mapping.children.concat [sc("command"), qsc(command)] if command
      service_mapping.children.concat [sc("ports"), seq(ports.map { |x| qsc x })] if ports
      service_mapping.children.concat [sc("volumes"), seq(volumes.map { |x| qsc x })] if volumes
      service_mapping.children.concat [sc("links"), seq(links.map { |x| qsc x })] unless links.empty?
      service_mapping.children.concat [sc("environment"), seq(environment.map { |x| qsc x })] unless environment.empty?

      [sc(name), service_mapping]
    end
  end
end
