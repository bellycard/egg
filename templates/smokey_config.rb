# frozen_string_literal: true
SmokeyGem::Configuration.new do |config|
  # Do stuff here.

  # Example dockerfile config.
  # Available arguments for use: ["Ruby", "NodeJS"]
  # self.dockerfile = Dockerfile.use "Ruby"
  # self.dockerfile.ruby_version = "2.4.0"
  # self.dockerfile.command = "bin/rails server -p 3000"

  # Example docker_compose config:
  # app = config.docker_compose.service "app"
  # app.ports = ["3000:3000"]
  # app.volumes = [".:/app"]

  # db = config.docker_compose.service "db"
  # db.image = "mysql"
  # db.env "MYSQL_ROOT_PASSWORD", "mysqliswebscale"
  # app.link db

  # after_startup do
  #   docker_exec "app", "rake db:setup db:seed"
  #   dotenv.set("foo", "bar")
  #   File.write(".env", dotenv.generate_env)
  # end
end
