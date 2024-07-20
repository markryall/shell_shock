# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/spec_helper"

describe ShellShock::ExitCommand do
  extend ShellShock::CommandSpec
  with_usage ""
  with_help "exits the current context"

  before do
    @context = stub("context")
    @command = ShellShock::ExitCommand.new @context
  end

  it "should abort context when executed" do
    @context.should_receive(:abort!)
    @command.execute ""
  end
end
