# frozen_string_literal: true

Egg::Configuration.new do |config|
  # Do stuff here.

  # after_startup do
  #   docker_exec "app", "rake db:setup db:seed"
  #   dotenv.set("foo", "bar")
  #   File.write(".env", dotenv.generate_env)
  # end
end
