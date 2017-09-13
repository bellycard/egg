# frozen_string_literal: true

# Provides Generic support for manipulating Dotenv files
class DotenvUtil

  # Retrieved from https://github.com/bkeepers/dotenv/blob/master/lib/dotenv/parser.rb
  LINE = /
      \A
      \s*
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # optional value begin
        '(?:\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\n]+         #   unquoted value
      )?                # value end
      \s*
      (?:\#.*)?         # optional comment
      \z
    /x

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
      val = %("#{val}") if val =~ /\s/
      "#{key}=#{val}"
    end.join("\n")
  end

  private

  def parse_env_file
    env_text.split.each_with_object({}) do |line, hash|
      match = line.match(LINE)
      next unless match
      hash.store(*match.captures)
      hash
    end
  end
end
