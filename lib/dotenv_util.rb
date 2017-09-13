# frozen_string_literal: true

# Provides Generic support for manipulating Dotenv files
class DotenvUtil
  ENV_LINE_PATTERN = /^ # A line
    (?<key>[A-Z_]+) # Beginning with al alphanumeric key
    =               # Then an equals sign
    (?<quot>"|')?   # Possibly a quote sign
    (?<val>[^"']+)? # The value, anything other than quote signs
    (\g<quot>)?     # If there was a quote sign, match its partner
    $/x # End of line (x = allow free spacing)

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
      match = line.match(ENV_LINE_PATTERN)
      next unless match
      hash.store(match[:key], match[:val])
      hash
    end
  end
end
