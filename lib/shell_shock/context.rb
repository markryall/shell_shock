# frozen_string_literal: true

require "rubygems"
require "readline"
require "shell_shock/exit_command"
require "shell_shock/help_command"
require "shell_shock/logger"

module ShellShock
  module Context
    include Logger

    def head_tail(string)
      if string
        m = /[^ ]+/.match(string.strip)
        return m[0], m.post_match.strip if m
      end
      ["", ""]
    end

    def refresh
      refresh_commands if respond_to?(:refresh_commands)
      Readline.completer_word_break_characters = ""
      Readline.completion_proc = lambda do |string|
        log { "trying completion for \"#{string}\"" }
        first, rest = head_tail(string)
        log { "split \"#{first}\" from \"#{rest}\"" }
        if first
          command = @commands[first]
          if command
            log { "matched #{first} command" }
            if command.respond_to?(:completion)
              completions = command.completion(rest).map { |c| "#{first} #{c}" }
            else
              log { "#{first} has no completion proc" }
              completions = []
            end
          end
        end

        completions ||= @commands.keys.grep(/^#{Regexp.escape(first)}/).sort
        log { "returning #{completions.inspect} completions" }
        completions
      end
    end

    def abort!
      @abort = true
    end

    def abort?
      @abort
    end

    def add_command command, *aliases
      @commands ||= {}
      aliases.each { |a| @commands[a] = command }
    end

    def push
      @prompt ||= " > "
      add_command HelpCommand.new(@commands), "?", "help"
      add_command ExitCommand.new(self), "exit", "quit"
      begin
        until abort?
          refresh
          line = Readline.readline(@prompt, true)
          if line
            first, rest = head_tail(line)
            log { "looking for command \"#{first}\" with parameter \"#{rest}\"" }
            if @commands[first]
              @commands[first].execute rest
            else
              puts "unknown command \"#{first}\""
            end
          else
            abort!
          end
          puts
        end
      rescue Interrupt
        puts
      end
    end
  end
end
