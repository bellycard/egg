# frozen_string_literal: true
SmokeyGem::Configuration.new do |config|
  # Do stuff here.

  # Example docker_compose config:
  # app = config.docker_compose.service "app"
  # app.dockerfile = "Dockerfile"
  # app.command = "rails s -p 3000"
  # app.ports = "3000:3000"
  # app.volumes = ".:/app"

  # db = config.docker_compose.service "db"
  # db.image = "mysql"
  # app.link db
end
