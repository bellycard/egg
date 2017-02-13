# frozen_string_literal: true
require "erb"

module SmokeyGem
  # Aids in the loading of template files bundled in the gem.
  class Templates
    def self.[](filename)
      templates_path = File.expand_path("../../../templates", __FILE__)
      ERB.new(File.read(File.join(templates_path, filename)))
    end
  end
end
