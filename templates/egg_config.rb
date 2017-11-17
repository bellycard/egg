# frozen_string_literal: true

Egg::Configuration.new do |config|
  # Do stuff here.

  # Example dockerfile config.
  # Available arguments for use: ["Ruby", "NodeJS"]
  # self.dockerfile = Dockerfile.use "Ruby"
  # self.dockerfile.ruby_version = "2.4.0"
  # self.dockerfile.command = "bin/rails server -p 3000"
  # self.dockerfile.env(dotenv.env)

  # after_startup do
  #   docker_exec "app", "rake db:setup db:seed"
  #   dotenv.set("foo", "bar")
  #   File.write(".env", dotenv.generate_env)
  # end
end
