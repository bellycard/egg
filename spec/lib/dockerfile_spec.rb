require "spec_helper"
require "egg/dockerfile"

RSpec.describe Egg::Dockerfile do
  let(:df) do
    df = Egg::Dockerfile.use("Ruby")
    df.command = "test"
    df.ruby_version = "2.3.3"
    df
  end

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

    it "raises an exception if both before and after are specified" do
      expect {
        df.run "echo before bundling", before: [:run, "bundle install"], after: [:run, "bundle install"]
      }.to raise_error(Egg::Dockerfile::Base::QuantumStateError)
    end
  end

  describe "command" do
    it "Appends the command at the end" do
      expect(df.render).to match(/CMD test$/)
    end
  end

  describe "#env" do
    it "Appends a ENV directive" do
      df.env(FOO: "ENV SET")
      expect(df.render).to match(/ENV FOO="ENV SET"/)
    end

    it "May append multiple vars" do
      df.env(FOO: "ENV SET", bar: "SetAnother123")
      expect(df.render).to match(/ENV FOO="ENV SET" BAR="SetAnother123"/)
    end
  end

  describe "#add" do
    it "Appends an ADD directive" do
      df.add "testfile", "testLocation"
      expect(df.render).to match(/ADD testfile testLocation/)
    end

    it "Allows the ADD to be added after another directive" do
      df.add("testfile", "testLocation", after: [:add, "Gemfile* $APP_HOME/"])
      expect(df.render).to match(%r{ADD Gemfile\* \$APP_HOME/\nADD testfile testLocation})
    end
  end
end
