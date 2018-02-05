# frozen_string_literal: true

require "spec_helper"
require "dotenv_util"

RSpec.describe DotenvUtil do
  let(:env_text) do
    <<-EOF
      FAVORITE_FOOD=POTATO
      FAVORITE_COLOR="RED"
      NO_CONTENT=
    EOF
  end

  describe "#generate_env" do
    it "Replaces an env variable in the file with a given string, quoting if necessary" do
      util = DotenvUtil.new(env_text)
      util.set("FAVORITE_FOOD", "FILET MIGNON")
      new_env = util.generate_env

      expect(new_env).to match(/FAVORITE_FOOD="FILET MIGNON"\s/)
    end

    it "Sets a new env variable which doesn't exist in the file" do
      util = DotenvUtil.new(env_text)
      util.set("BANANA", "YES")
      new_env = util.generate_env

      expect(new_env).to match(/BANANA=YES/)
    end

    it "Doesn't mess up by putting an extra quote around the val" do
      util = DotenvUtil.new(env_text)
      new_env = util.generate_env
      expect(new_env).to match(/FAVORITE_COLOR="RED"\s/)
    end

    it "Has no problem when the has no values" do
      empty_envs = <<-EOF
        NOTHING=
        ALSO_NOTHING=
      EOF

      expect { DotenvUtil.new(empty_envs) }.to_not raise_error
    end

    it "Can handle non-matching lines like comments" do
      commented_contents = <<-EOF
        FOO=BAR
        # FOO=OLDBAR
      EOF

      expect { DotenvUtil.new(commented_contents) }.to_not raise_error
    end
  end
end
