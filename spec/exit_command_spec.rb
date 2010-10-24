require File.dirname(__FILE__)+'/spec_helper'

describe ShellShock::ExitCommand do
  it 'should abort context when executed' do
    context = stub('context')
    context.should_receive(:abort!)
    ShellShock::ExitCommand.new(context).execute ''
  end
end