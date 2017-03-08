# frozen_string_literal: true

# Provides Generic support for manipulating Dotenv files
class DotenvUtil
  attr_reader :env_text, :env
  def initialize(env_file)
    @env_text = env_file
    @env = parse_env_file
  end

  def set(target, value)
    env[target] = value
  end

  def generate_env
    env.collect do |key, val|
      %(#{key}="#{val}")
    end.join("\n")
  end

  private

  def parse_env_file
    env_text.split.each_with_object({}) do |line, hash|
      hash.store(*line.match(/^([A-Z_]+)="?(.+)?"?$/).captures)
      hash
    end
  end
end
