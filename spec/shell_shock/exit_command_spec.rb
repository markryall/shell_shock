# frozen_string_literal: true

require_relative "../spec_helper"

describe ShellShock::ExitCommand do
  extend ShellShock::CommandSpec

  with_usage ""
  with_help "exits the current context"

  before do
    @context = double("context", abort!: nil)
    @command = described_class.new @context
  end

  it "aborts context when executed" do
    @command.execute ""

    expect(@context).to have_received(:abort!)
  end
end
