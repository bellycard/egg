# frozen_string_literal: true
require "docker_compose"

RSpec.describe DockerCompose do
  it "generates a valid, empty docker_compose file" do
    dc = DockerCompose.new
    dc_yaml = dc.to_yaml

    hash = YAML.safe_load(dc_yaml)
    expect(hash["version"]).to eq("2")
  end

  it "allows one to define an app service built from a local dockerfile" do
    dc = DockerCompose.new
    app_service = DockerCompose::Service.new("app",
                                             dockerfile: "woop-woop",
                                             command: "rails s -p 3000",
                                             ports: ["3000:3000"],
                                             volumes: [".:/app"])
    dc.services << app_service

    dc_yaml = dc.to_yaml
    hash = YAML.safe_load(dc_yaml)
    p hash
    service = hash.dig("services", "app")
    expect(service["build"]).to eq(".")
    expect(service["command"]).to eq("rails s -p 3000")
    expect(service["ports"][0]).to eq("3000:3000")
    expect(service["volumes"][0]).to eq(".:/app")
  end
end
