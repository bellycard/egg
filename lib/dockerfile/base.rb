module Dockerfile
  # Provides shared behavior for dockerfile template classes.
  class Base
    attr_reader :template
    attr_accessor :command

    def initialize
      raise "Must define a subclass initializer that populates @template"
    end

    def required_attributes
      [:command]
    end

    def render
      required_attributes.each do |attr|
        raise(MissingPropertyError, "Must populate #{attr}") if send(attr).nil?
      end

      template.result(binding)
    end
  end
end