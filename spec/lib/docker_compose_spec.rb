# frozen_string_literal: true
require "smokey_gem/docker_compose"

RSpec.describe DockerCompose do
  it "generates a valid, empty docker_compose file" do
    dc = DockerCompose.new
    dc_yaml = dc.to_yaml

    hash = YAML.safe_load(dc_yaml)
    expect(hash["version"]).to eq("2")
  end

  it "allows one to define an app service built from a local dockerfile" do
    dc = DockerCompose.new
    app = dc.service("app")
    app.dockerfile = "Dockerfile"
    app.command = "rails s -p 3000"
    app.ports = ["3000:3000"]
    app.volumes = [".:/app"]

    dc_yaml = dc.to_yaml
    hash = YAML.safe_load(dc_yaml)
    service = hash.dig("services", "app")
    expect(service["build"]).to eq(".")
    expect(service["command"]).to eq("rails s -p 3000")
    expect(service["ports"][0]).to eq("3000:3000")
    expect(service["volumes"][0]).to eq(".:/app")
  end

  it "allows me to define a service based on an image" do
    dc = DockerCompose.new

    db = dc.service("db")
    db.image = "postgres"
    dc_yaml = dc.to_yaml
    hash = YAML.safe_load(dc_yaml)

    service = hash.dig("services", "db")
    expect(service["image"]).to eq("postgres")
  end

  it "allows me to define links between services" do
    dc = DockerCompose.new
    app = dc.service("app")
    app.dockerfile = "Dockerfile"
    app.command = "rails s -p 3000"
    app.ports = ["3000:3000"]
    app.volumes = [".:/app"]

    db = dc.service("db")
    db.image = "postgres"
    app.link(db)
    dc_yaml = dc.to_yaml
    hash = YAML.safe_load(dc_yaml)

    service = hash.dig("services", "app")
    expect(service["links"][0]).to eq("db")
  end
end
