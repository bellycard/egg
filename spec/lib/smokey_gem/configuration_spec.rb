# frozen_string_literal: true

require "spec_helper"
require "leash"
require "dotenv_util"

RSpec.describe Leash::Configuration do
  describe "#database_url" do
    it "Sets up the database url as a postgres database" do
      database_url = "postgres://leash:postgreswins@db/leash_database"

      tmp_env_text = <<-EOF
        DATABASE_URL=
      EOF

      env_util = DotenvUtil.new(tmp_env_text)
      env_util.set("DATABASE_URL", database_url)
      update_env_file = env_util.generate_env

      written_db_url = update_env_file
                       .match(/^DATABASE_URL="(?<url>.*)"$/)[:url]
      expect(written_db_url).to eq(database_url)
    end
  end
end
