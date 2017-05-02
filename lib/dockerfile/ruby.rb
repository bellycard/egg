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
      file_dirname = File.dirname(__FILE__)
      file_join = File.join(file_dirname, "ruby", "Dockerfile")
      file_read = File.read(file_join)
      @template = ERB.new(file_read)
    end
  end
end