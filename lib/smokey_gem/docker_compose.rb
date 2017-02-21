# frozen_string_literal: true
require "yaml"
require "shrink"

# Wraps the generation of Docker Compose file
class DockerCompose
  include Shrink
  attr_reader :docker_compose,
              :services

  def initialize(_compose_config = {})
    @services = []
  end

  def configure
    yield docker_compose
  end

  def to_yaml
    output = Psych::Nodes::Stream.new
    output.children << doc = Psych::Nodes::Document.new
    doc.children << m(
      [sc("version"), qsc("2")],
      [sc("services"), m(services.flat_map(&:to_yaml))]
    )

    output.to_yaml
  end

  def service(name, attributes)
    service = Service.new(name, attributes)
    services << service
    service
  end
end

require_relative "docker_compose/service"
