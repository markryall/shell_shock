module ShellShock
  class ExitCommand
    attr_reader :help, :usage

    def initialize context
      @context = context
      @usage = ''
      @help = 'exits the current context'
    end

    def execute ignore
      @context.abort!
    end
  end  
end