module Egg
  # Configures dockerfiles programmatically from templates.
  module Dockerfile
    class NoDockerfileError < StandardError; end
    class MissingPropertyError < StandardError; end

    def self.use(klass)
      const_get("Egg::Dockerfile::#{klass}").new
    rescue NameError
      raise(NoDockerfileError, "No Dockerfile subclass for #{klass}.")
    end
  end
end

require_relative "dockerfile/base"
require_relative "dockerfile/ruby"
require_relative "dockerfile/node_js"
