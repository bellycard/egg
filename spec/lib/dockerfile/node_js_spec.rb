require "dockerfile"

RSpec.describe Dockerfile::NodeJS do
  it "Is Available from #use" do
    expect(Dockerfile.use("NodeJS")).to be_an_instance_of(Dockerfile::NodeJS)
  end

  it "Can render from a template" do
    df = Dockerfile.use "NodeJS"
    df.command = %w(npm start)
    df.node_version = "7.9.0"
    expect(df.render).to match(/FROM node/)
  end

  it "Requires setting the nodeJS_version" do
    df = Dockerfile.use "NodeJS"
    df.command = ["bin/rails", "server", "-p 3000"]
    expect { df.render }.to raise_error(Dockerfile::MissingPropertyError)
      .with_message(/node_version/)
  end

  it "Requires setting the command" do
    df = Dockerfile.use "NodeJS"
    df.node_version = "2.4.0"
    expect { df.render }.to raise_error(Dockerfile::MissingPropertyError)
      .with_message(/command/)
  end
end
