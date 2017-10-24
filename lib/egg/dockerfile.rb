module Egg
  # Configures dockerfiles programmatically from templates.
  module Dockerfile
    class NoDockerfileError < StandardError; end
    class MissingPropertyError < StandardError; end

    def self.use(klass)
      print "Dockerfile.use is deprecated. Egg setup will no longer write your dockerfile, please craft it yourself."
      const_get("Egg::Dockerfile::#{klass}").new
    rescue NameError
      raise(NoDockerfileError, "No Dockerfile subclass for #{klass}.")
    end
  end
end

require_relative "dockerfile/base"
require_relative "dockerfile/ruby"
require_relative "dockerfile/node_js"
