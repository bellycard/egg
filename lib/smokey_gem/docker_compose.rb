# frozen_string_literal: true
require "yaml"

module SmokeyGem
  # Wraps the generation of Docker Compose file
  class DockerCompose
    attr_reader :docker_compose
    def initialize(compose_config = {})
      @docker_compose = {
        "version" => "2"
      }.merge(compose_config)
    end

    def configure
      yield docker_compose
    end

    def to_yaml
      docker_compose.to_yaml
    end
  end
end
