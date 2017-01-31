module SmokeyGem
  class Templates
    def self.[](filename)
      templates_path = File.expand_path("../../../templates", __FILE__)
      File.read(File.join(templates_path, filename))
    end
  end
end