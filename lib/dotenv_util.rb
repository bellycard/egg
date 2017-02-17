# frozen_string_literal: true

# Provides Generic support for manipulating Dotenv files
class DotenvUtil
  attr_reader :config, :env_file
  def initialize(env_file)
    @env_file = env_file
    @env_hash = parse_env_file
  end

  def set(target, value)
    @env_hash[target] = value
  end

  def generate_env
    out = Tempfile.new
    @env_hash.each do |key, val|
      out << %(#{key}="#{val}"\n)
    end
    out.tap(&:rewind)
  end

  private

  def parse_env_file
    @env_file.read.split.each_with_object({}) do |line, hash|
      hash.store(*line.match(/^([A-Z_]+)="?(.+)?"?$/).captures)
      hash
    end
  end
end
