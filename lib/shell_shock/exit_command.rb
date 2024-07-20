# frozen_string_literal: true

module ShellShock
  class ExitCommand
    attr_reader :help, :usage

    def initialize(context)
      @context = context
      @usage = ""
      @help = "exits the current context"
    end

    def execute(_ignore)
      @context.abort!
    end
  end
end
