module SmokeyGem
  class DockerCompose
    attr_reader :docker_compose
    def initialize(compose_config)
      @docker_compose = {
        "version" => "2"
      }.merge(compose_config)
    end

    def to_yaml
      docker_compose.to_yaml
    end
  end
end