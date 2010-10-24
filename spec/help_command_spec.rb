require File.dirname(__FILE__)+'/spec_helper'

describe ShellShock::HelpCommand do
  extend ShellShock::CommandSpec
  with_usage '<command name>'
  with_help 'displays the help information for a command'

  before do
    @commands = stub('commands')
    @command = ShellShock::HelpCommand.new @commands
    @command.stub!(:puts)
  end

  it 'should list commands when executed without arguments' do
    @commands.should_receive(:keys).and_return([])
    @command.should_receive(:puts).with('Available commands:')
    @command.execute ''
  end

  it "should show error when executed with an argument for a command that doesn't exist" do
    @commands.should_receive(:[]).with('command').and_return nil
    @command.should_receive(:puts).with('unknown command "command"')
    @command.execute 'command'
  end

  it 'should show help for command when executed with an argument' do
    other_command = stub('command')
    @commands.should_receive(:[]).with('command').and_return(other_command)
    @command.execute 'command'
  end
end