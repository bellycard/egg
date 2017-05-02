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
end
