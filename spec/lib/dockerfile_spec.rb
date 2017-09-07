require "spec_helper"
require "egg/dockerfile"

RSpec.describe Egg::Dockerfile do
  it "can be configured with a #use" do
    df = Egg::Dockerfile.use("NodeJS")
    expect(df).to be_an_instance_of(Egg::Dockerfile::NodeJS)
  end

  it "Doesn't allow #use for templates that dont exist" do
    expect do
      Egg::Dockerfile.use("FooLang")
    end.to raise_error(Egg::Dockerfile::NoDockerfileError)
  end

  describe "#run" do
    it "Appends another RUN action" do
      df = Egg::Dockerfile.use("Ruby")
      df.command = "test"
      df.ruby_version = "2.3.3"
      df.run "echo awesomesauce"
      expect(df.render).to match(/^RUN echo awesomesauce$/)
    end

    it "Allows you to run some commands before a specific command" do
      df = Egg::Dockerfile.use("Ruby")
      df.command = "test"
      df.ruby_version = "2.3.3"
      df.run "echo before bundling", before: [:run, "bundle install"]
      expect(df.render).to match(/^RUN echo before bundling\nRUN bundle install$/)
    end
  end

  describe "command" do
    it "Appends the command at the end" do
      df = Egg::Dockerfile.use("Ruby")
      df.command = "test"
      df.ruby_version = "2.3.3"
      expect(df.render).to match(/CMD test$/)
    end
  end
end
