module Dockerfile
  # Wrapper for templating of NodeJS Dockerfile
  class NodeJS < Base
    def required_attributes
      super + [:node_version]
    end

    attr_accessor :node_version
    def initialize
      file_dirname = File.dirname(__FILE__)
      file_join = File.join(file_dirname, "node_js", "Dockerfile")
      file_read = File.read(file_join)
      @template = ERB.new(file_read)
    end
  end
end
