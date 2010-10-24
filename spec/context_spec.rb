require File.dirname(__FILE__)+'/spec_helper'

class TestContext
  attr_reader :commands, :prompt, :out

  include ShellShock::Context

  def puts message=nil
    @out ||= []
    @out << message
  end
end

describe TestContext do
  before do
    Readline.stub! :readline 
    @context = TestContext.new
    @context.stub! :puts
  end

  it 'should initialise commands if there are none in push' do
    @context.push
    @context.commands.should_not be_nil
  end

  it 'should set up a default prompt in push' do
    @context.push
    @context.prompt.should == ' > '
  end

  it 'should add help and exit commands' do
    @context.push
    @context.commands.keys.sort.should == ['?', 'exit', 'help', 'quit']
  end

  it 'should call readline with configured prompt and store history' do
    Readline.should_receive(:readline).with(' > ', true)
    @context.push
  end
end