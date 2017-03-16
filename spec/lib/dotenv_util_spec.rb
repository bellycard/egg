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

  describe "#replace_env" do
    it "Replaces an env variable in the file with a given string" do
      util = DotenvUtil.new(env_text)
      util.set("FAVORITE_FOOD", "FILET MIGNON")
      new_env = util.generate_env

      favorite_food = new_env.match(/^FAVORITE_FOOD="(?<env>.*)"$/)[:env]
      expect(favorite_food).to eq "FILET MIGNON"
    end

    it "Sets a new env variable which doesn't exist in the file" do
      util = DotenvUtil.new(env_text)
      util.set("BANANA", "YES")
      new_env = util.generate_env

      banananess = new_env.match(/^BANANA="(?<env>.*)"$/)[:env]
      expect(banananess).to eq "YES"
    end
  end
end
