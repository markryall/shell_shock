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

  it 'should not call readline when aborted' do
    Readline.should_not_receive :readline
    @context.abort!
    @context.push
  end

  it 'should perform refresh_commands callback' do
    @context.should_receive :refresh_commands
    @context.push
  end

  it 'should return blank strings from head_tail for nil string' do
    head, tail = @context.head_tail nil
    head.should == ''
    tail.should == ''
  end

  it 'should return blank strings from head_tail for blank string' do
    head, tail = @context.head_tail ''
    head.should == ''
    tail.should == ''
  end

  it 'should split the head from the tail with a single word' do
    head, tail = @context.head_tail 'a'
    head.should == 'a'
    tail.should == ''
  end

  it 'should split the head from the tail with a single word with trailing whitespace' do
    head, tail = @context.head_tail 'a '
    head.should == 'a'
    tail.should == ''
  end

  it 'should split the head from the tail with multiple words' do
    head, tail = @context.head_tail 'a b c '
    head.should == 'a'
    tail.should == 'b c'
  end
end