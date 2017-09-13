# frozen_string_literal: true

require "spec_helper"
require "egg"
require "dotenv_util"

RSpec.describe Egg::Configuration do
  describe "#database_url" do
    it "Sets up the database url as a postgres database" do
      database_url = "postgres://egg:postgreswins@db/egg_database"

      tmp_env_text = <<-EOF
        DATABASE_URL=
      EOF

      env_util = DotenvUtil.new(tmp_env_text)
      env_util.set("DATABASE_URL", database_url)
      update_env_file = env_util.generate_env

      expect(update_env_file).to match %r{DATABASE_URL=postgres://egg:postgreswins@db/egg_database}
    end
  end
end
