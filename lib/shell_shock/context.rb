require 'rubygems'
require 'readline'

module ShellShock
  module Logger
    def log message
      return unless ENV['LOG_PATH']
      File.open(ENV['LOG_PATH'], 'a') do |file|
        file.puts message
      end
    end
  end

  class HelpCommand
    def initialize commands
      @commands = commands
    end

    def usage
      '<command name>'
    end

    def help
      'displays the help information for a command'
    end

    def completion text
      @commands.keys.grep(/^#{Regexp.escape(text)}/).sort
    end

    def execute command
      if command.empty?
        puts 'Available commands:'
        @commands.keys.sort.each { |command| puts command }        
      else
        display_help_for_command command
      end
    end

    def display_help_for_command command_name
      command = @commands[command_name]
      if command
        puts "Command \"#{command_name}\""
        puts "Usage: #{command_name} #{command.usage}" if command.respond_to?(:usage)
        puts "Help:\n #{command.help}" if command.respond_to?(:help)
      else
        puts "no help available for command \"#{command_name}\""
      end
    end
  end

  module Context
    include Logger

    def head_tail string
      if string
        m = /[^ ]+/.match(string.strip)
        return m[0], m.post_match.strip if m
      end
      return '', ''
    end

    def refresh
      refresh_commands if respond_to?(:refresh_commands)
      Readline.completer_word_break_characters = ''
      Readline.completion_proc = lambda do |string|
        log "trying completion for \"#{string}\""
        first, rest = head_tail(string)
        log "split \"#{first}\" from \"#{rest}\""
        if first
          command = @commands[first]
          if command
            log "matched #{first} command"
            if command.respond_to?(:completion)
              completions = command.completion(rest).map {|c| "#{first} #{c}" }
            else
              log "#{first} has no completion proc"
              completions = []
            end
          end
        end

        completions ||= @commands.keys.grep( /^#{Regexp.escape(first)}/ ).sort
        log "returning #{completions.inspect} completions"
        completions
      end
    end

    def push
      help = HelpCommand.new @commands
      @commands['?'] = help
      @commands['help'] = help
      finished = false
      begin
        until finished 
          refresh
          line = Readline.readline(@prompt_text, true)
          if line
            first, rest = head_tail(line)
            log "looking for command \"#{first}\" with parameter \"#{rest}\""
            if ['quit', 'exit'].include? first
              finished = true
            else
              if @commands[first]
                @commands[first].execute rest
              else
                puts "unknown command \"#{first}\""
              end
            end
          else
            finished = true
          end
          puts
        end
      rescue Interrupt => e
        puts
      end
    end
  end
end