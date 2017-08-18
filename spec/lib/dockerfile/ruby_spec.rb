require "egg/dockerfile"

RSpec.describe Egg::Dockerfile::Ruby do
  it "Is Available from #use" do
    expect(Egg::Dockerfile.use("Ruby")).to be_an_instance_of(Egg::Dockerfile::Ruby)
  end

  it "Can render from a template" do
    df = Egg::Dockerfile.use "Ruby"
    df.command = ["bin/rails", "server", "-p 3000"]
    df.ruby_version = "2.4.0"
    expect(df.render).to match(/FROM ruby/)
  end

  it "Requires setting the ruby_version" do
    df = Egg::Dockerfile.use "Ruby"
    df.command = ["bin/rails", "server", "-p 3000"]
    expect { df.render }.to raise_error(Egg::Dockerfile::MissingPropertyError)
      .with_message(/ruby_version/)
  end

  it "Requires setting the command" do
    df = Egg::Dockerfile.use "Ruby"
    df.ruby_version = "2.4.0"
    expect { df.render }.to raise_error(Egg::Dockerfile::MissingPropertyError)
      .with_message(/command/)
  end
end
