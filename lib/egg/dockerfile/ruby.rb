module Egg
  module Dockerfile
    # Ruby Dockerfile Template
    # Required Attributes:
    # @ruby_version: Version of Ruby to use for the ruby image.
    class Ruby < Base
      def required_attributes
        super + [:ruby_version]
      end

      attr_accessor :ruby_version

      def initialize
        @template = dockerfile
      end

      private

      def dockerfile # rubocop:disable Metrics/MethodLength
        [
          [:from, "ruby:<%= ruby_version %>"],
          [:run, "apt-get update -qq && apt-get upgrade -qqy"],
          [:run, "apt-get -qqy install cmake"],
          [:run, "gem install bundler"],
          [:env, "APP_HOME /app"],
          [:run, "mkdir $APP_HOME"],
          [:workdir, "$APP_HOME"],
          [:add, ".ruby-version $APP_HOME/"],
          [:add, "Gemfile* $APP_HOME/"],
          [:env, "BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=4 BUNDLE_WITHOUT=production:staging"],
          [:run, "bundle install"],
          [:add, ". $APP_HOME"],
          [:cmd, "<%= command %>"]
        ]
      end
    end
  end
end
