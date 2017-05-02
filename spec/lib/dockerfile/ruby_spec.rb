require "dockerfile"

RSpec.describe Dockerfile::Ruby do
  it "Is Available from #use" do
    expect(Dockerfile.use("Ruby")).to be_an_instance_of(Dockerfile::Ruby)
  end

  it "Can render from a template" do
    df = Dockerfile.use "Ruby"
    df.command = ["bin/rails", "server", "-p 3000"]
    df.ruby_version = "2.4.0"
    expect(df.render).to match(/FROM ruby/)
  end

  it "Requires setting the ruby_version" do
    df = Dockerfile.use "Ruby"
    df.command = ["bin/rails", "server", "-p 3000"]
    expect { df.render }.to raise_error(Dockerfile::MissingPropertyError)
      .with_message(/ruby_version/)
  end

  it "Requires setting the command" do
    df = Dockerfile.use "Ruby"
    df.ruby_version = "2.4.0"
    expect { df.render }.to raise_error(Dockerfile::MissingPropertyError)
      .with_message(/command/)
  end
end
