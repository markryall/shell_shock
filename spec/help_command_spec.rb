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

  it 'should list nothing when executed without arguments and there are no commands' do
    @commands.should_receive(:keys).and_return([])
    @command.should_not_receive(:puts)
    @command.execute ''
  end

  it 'should list commands when executed without arguments and there are commands' do
    @commands.stub!(:keys).and_return(['command'])
    @command.should_receive(:puts).with('Available commands:')
    @command.should_receive(:puts).with('command')
    @command.execute ''
  end

  it "should show error when executed with an argument for a command that doesn't exist" do
    @commands.should_receive(:[]).with('command').and_return nil
    @command.should_receive(:puts).with('unknown command "command"')
    @command.execute 'command'
  end

  it 'should show command when executed with an argument' do
    other_command = stub('command')
    @commands.should_receive(:[]).with('command').and_return(other_command)
    @command.should_receive(:puts).with('Command "command"')
    @command.execute 'command'
  end

  it 'should show help, usage and  for command when executed with an argument' do
    other_command = stub('command', :usage => '<usage>', :help => 'helpful stuff')
    @commands.should_receive(:[]).with('command').and_return(other_command)
    @command.should_receive(:puts).with('Command "command"')
    @command.should_receive(:puts).with('Usage: command <usage>')
    @command.should_receive(:puts).with("Help:\n helpful stuff")
    @command.execute 'command'
  end

  it 'should return empty list from completion proc when there are no commands' do
    @commands.stub!(:keys).and_return([])
    @command.completion('').should == []
  end

  it 'should return sorted command names from completion proc when there are commands' do
    @commands.stub!(:keys).and_return(['a', 'c', 'b'])
    @command.completion('').should == ['a', 'b', 'c']
  end

  it 'should return filtered and sorted command names from completion proc with argument when there are commands' do
    @commands.stub!(:keys).and_return(['aa', 'c', 'ab'])
    @command.completion('a').should == ['aa', 'ab']
  end
end