# frozen_string_literal: true

require "yaml"

# Wraps the generation of Docker Compose file
class DockerCompose
  attr_reader :docker_compose,
              :services

  def initialize(_compose_config = {})
    @services = []
    print "Use of docker_compose is deprecated. Please craft the docker-compose.yml file yourself. This module will be dropped in a future egg."
  end

  def configure
    yield docker_compose
  end

  def to_yaml
    output = { "version" => "2" }
    output["services"] = services.each_with_object({}) do |service, hash|
      hash[service.name] = service.to_hash
    end

    output.to_yaml
  end

  def service(name)
    service = Service.new(name)
    services << service
    service
  end
end

require_relative "docker_compose/service"
