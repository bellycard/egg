# Module that wraps configuration of Dockerfiles from Templates.
module Dockerfile
  class NoDockerfileError < StandardError; end
  class MissingPropertyError < StandardError; end

  def self.use(klass)
    const_get("Dockerfile::#{klass}").new
  rescue NameError
    raise(NoDockerfileError, "No Dockerfile subclass for #{klass}.")
  end
end

require_relative "dockerfile/base"
require_relative "dockerfile/ruby"
require_relative "dockerfile/node_js"