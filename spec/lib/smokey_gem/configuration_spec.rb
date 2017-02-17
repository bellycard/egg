# frozen_string_literal: true
require "spec_helper"
require "smokey_gem"
require "dotenv_util"

RSpec.describe SmokeyGem::Configuration do
  describe "#database_url" do
    it "Sets the database_url variable in the dotenv file" do
      database_url = "postgres://smokey:postgreswins@db/smokey_database"

      config = SmokeyGem::Configuration.new do
        self.database_url = database_url
      end

      tmp_env_file = Tempfile.new(".env")
      tmp_env_file.write <<-EOF
        DATABASE_URL=
      EOF

      env_util = DotenvUtil.new(config, tmp_env_file)
      update_env_file = env_util.generate_env

      written_db_url = update_env_file
                       .tap(&:rewind)
                       .read
                       .match(/^DATABASE_URL=(?<url>.*)$/)[:url]
      expect(written_db_url).to eq(database_url)
    end
  end
end
