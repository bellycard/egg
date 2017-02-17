# frozen_string_literal: true

# Provides Generic support for manipulating Dotenv files
class DotenvUtil
  attr_reader :config, :env_file
  def initialize(config, env_file)
    @config = config
    @env_file = env_file
  end

  def generate_env
    out = Tempfile.new
    out << "DATABASE_URL=postgres://smokey:postgreswins@db/smokey_database"
    out
  end
end
