# frozen_string_literal: true

# :nodoc:
module Egg
  def self.root_join(*joins)
    path_parts = [File.dirname(__FILE__)] + joins.map(&:to_s)
    joined_path = File.join(*path_parts)
    File.expand_path(joined_path)
  end
end

require_relative "egg/version"
require_relative "egg/cli"
require_relative "egg/templates"
require_relative "egg/configuration"
require_relative "egg/docker_compose"
