# frozen_string_literal: true

# :nodoc:
module Leash
  def self.root_join(*joins)
    path_parts = [File.dirname(__FILE__)] + joins.map(&:to_s)
    joined_path = File.join(*path_parts)
    File.expand_path(joined_path)
  end
end

require_relative "leash/version"
require_relative "leash/cli"
require_relative "leash/templates"
require_relative "leash/configuration"
require_relative "leash/docker_compose"
