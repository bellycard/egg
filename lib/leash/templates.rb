# frozen_string_literal: true

require "erb"

module Leash
  # Aids in the loading of template files bundled in the gem.
  class Templates
    class TemplateNotFoundError < StandardError; end

    def self.[](filename)
      template_path = Leash.root_join("..", "templates", filename)
      raise(TemplateNotFoundError, "No #{filename}") unless File.exist?(template_path)
      ERB.new(File.read(template_path))
    end
  end
end
