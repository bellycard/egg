# frozen_string_literal: true
SmokeyGem::Configuration.new do |config|
  # Do stuff here.

  # Example dockerfile config.
  # Available arguments for use: ["Ruby", "NodeJS"]
  # dockerfile.use :ruby
  # dockerfile.command = [["bin/rails", "server", "-p 3000"]]

  # Example docker_compose config:
  # app = config.docker_compose.service "app"
  # app.ports = "3000:3000"
  # app.volumes = ".:/app"

  # db = config.docker_compose.service "db"
  # db.image = "mysql"
  # app.link db
end
