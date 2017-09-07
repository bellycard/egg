require "egg/dockerfile"

RSpec.describe Egg::Dockerfile::NodeJS do
  it "Is Available from #use" do
    expect(Egg::Dockerfile.use("NodeJS")).to be_an_instance_of(Egg::Dockerfile::NodeJS)
  end

  it "Can render from a template" do
    df = Egg::Dockerfile.use "NodeJS"
    df.command = "npm start"
    df.node_version = "7.9.0"
    expect(df.render).to match(/FROM node/)
  end

  it "Requires setting the nodeJS_version" do
    df = Egg::Dockerfile.use "NodeJS"
    df.command = "npm start"
    expect { df.render }.to raise_error(Egg::Dockerfile::MissingPropertyError)
      .with_message(/node_version/)
  end

  it "Requires setting the command" do
    df = Egg::Dockerfile.use "NodeJS"
    df.node_version = "2.4.0"
    expect { df.render }.to raise_error(Egg::Dockerfile::MissingPropertyError)
      .with_message(/command/)
  end

  it "Renders the command at the end" do
    df = Egg::Dockerfile.use "NodeJS"
    df.command = "npm start"
    df.node_version = "7.9.0"
    expect(df.render).to match(/CMD npm start$/)
  end
end
