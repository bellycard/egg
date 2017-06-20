module Dockerfile
  # Wrapper for templating of NodeJS Dockerfile
  class NodeJS < Base
    def required_attributes
      super + [:node_version]
    end

    attr_accessor :node_version

    def initialize
      @template = dockerfile
    end

    private

    def dockerfile # rubocop:disable Metrics/MethodLength
      [
        [:from, "node:<%= node_version %>"],
        [:env, "APP_HOME /app"],
        [:run, "mkdir $APP_HOME"],
        [:workdir, "$APP_HOME"],
        [:add, "package.json $APP_HOME/"],
        [:add, "yarn.lock $APP_HOME/"],
        [:run, "yarn install"],
        [:add, ". $APP_HOME"],
        [:cmd, "<%= command %>"]
      ]
    end
  end
end
