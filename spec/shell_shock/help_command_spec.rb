# frozen_string_literal: true

require_relative "../spec_helper"

describe ShellShock::HelpCommand do
  extend ShellShock::CommandSpec

  with_usage "<command name>"
  with_help "displays the help information for a command"

  before do
    @commands = double("commands", keys: [], ":[]": nil)
    @command = described_class.new @commands
    allow(@command).to receive(:puts)
  end

  it "lists nothing when executed without arguments and there are no commands" do
    @command.execute ""

    expect(@command).not_to have_received(:puts)
  end

  it "lists commands when executed without arguments and there are commands" do
    allow(@commands).to receive(:keys).and_return(["command"])

    @command.execute ""

    expect(@command).to have_received(:puts).with("Available commands:")
    expect(@command).to have_received(:puts).with("command")
  end

  it "shows error when executed with an argument for a command that doesn't exist" do
    allow(@commands).to receive(:[]).with("command").and_return(nil)

    @command.execute "command"

    expect(@command).to have_received(:puts).with('unknown command "command"')
  end

  it "shows command when executed with an argument" do
    allow(@commands).to receive(:[]).with("command").and_return(double("command"))

    @command.execute "command"

    expect(@command).to have_received(:puts).with('Command "command"')
  end

  it "shows help, usage and for command when executed with an argument" do
    command = double("command", usage: "the usage", help: "the help")
    allow(@commands).to receive(:[]).with("command").and_return(command)

    @command.execute "command"

    expect(@command).to have_received(:puts).with('Command "command"')
    expect(@command).to have_received(:puts).with("Usage: command the usage")
    expect(@command).to have_received(:puts).with("Help:\n the help")
  end

  it "returns empty list from completion proc when there are no commands" do
    allow(@commands).to receive(:keys).and_return([])

    expect(@command.completion("")).to eq([])
  end

  it "returns sorted command names from completion proc when there are commands" do
    allow(@commands).to receive(:keys).and_return(%w[a c b])

    expect(@command.completion("")).to eq(%w[a b c])
  end

  it "returns filtered and sorted command names from completion proc with argument when there are commands" do
    allow(@commands).to receive(:keys).and_return(%w[ab c aa])

    expect(@command.completion("a")).to eq(%w[aa ab])
  end
end
