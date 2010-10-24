module ShellShock
  class ExitCommand
    def initialize context
      @context = context
    end

    def usage
      ''
    end

    def help
      'exits the current context'
    end

    def execute ignore
      @context.abort!
    end
  end  
end