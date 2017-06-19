require "spec_helper"
require "dockerfile"

RSpec.describe Dockerfile do
  it "can be configured with a #use" do
    df = Dockerfile.use("NodeJS")
    expect(df).to be_an_instance_of(Dockerfile::NodeJS)
  end

  it "Doesn't allow #use for templates that dont exist" do
    expect do
      Dockerfile.use("FooLang")
    end.to raise_error(Dockerfile::NoDockerfileError)
  end

  describe "#run" do
    it "Appends another RUN action" do
      df = Dockerfile.use("Ruby")
      df.command = "test"
      df.ruby_version = "2.3.3"
      df.run "echo awesomesauce"
      expect(df.render).to match(/^RUN echo awesomesauce$/)
    end
  end
end
