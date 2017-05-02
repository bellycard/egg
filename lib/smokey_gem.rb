# frozen_string_literal: true

# :nodoc:
module SmokeyGem
  def self.root_join(*joins)
    path_parts = [File.dirname(__FILE__)] + joins.map(&:to_s)
    joined_path = File.join(*path_parts)
    File.expand_path(joined_path)
  end
end

require_relative "smokey_gem/version"
require_relative "smokey_gem/cli"
require_relative "smokey_gem/templates"
require_relative "smokey_gem/configuration"
require_relative "smokey_gem/docker_compose"