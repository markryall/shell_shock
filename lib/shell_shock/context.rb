require 'rubygems'
require 'readline'

module ShellShock
  module Context
    def refresh
      refresh_commands if respond_to?(:refresh_commands)
      Readline.completer_word_break_characters = ''
      Readline.completion_proc = lambda do |word|
        name, *words = word.scan(/[\w?]+/)
        if name
          command = @commands[name]
          if command
            if command.respond_to?(:completion)
              rest = words || []
              completions = command.completion(rest.join(' ')).map {|c| "#{name} #{c}" }
              return completions
            else
              return []
            end
          end
        end

        @commands.keys.grep( /^#{Regexp.escape(word)}/ ).sort
      end
    end

    def push
      refresh
      begin
        while line = Readline.readline(@prompt_text, true)
          line.strip!
          case line
            when /^([\w?]+) (.*)/
              return if ['quit', 'exit'].include?($1)
              process_command $1, $2
            when /^([\w?]+)/
              return if ['quit', 'exit'].include?($1)
              process_command $1
            else
              @io.say "can not process line \"#{line}\""
          end
          @io.say
          refresh
        end
      rescue Interrupt => e
        return
      end
      @io.say
    end

    def display_help_for_command command_name
      command = @commands[command_name]
      if command
        @io.say "Command \"#{command_name}\""
        @io.say "Usage: #{command_name} #{command.usage}" if command.respond_to?(:usage)
        @io.say "Help:\n #{command.help}" if command.respond_to?(:help)      
      else
        @io.say "no help available for command \"#{command_name}\""
      end
    end

    def process_help command=nil
      if command
        display_help_for_command command
      else
        @io.say "Available commands:"
        @commands.keys.sort.each { |command| @io.say command }
        @io.say
      end      
    end

    def process_command name, parameter=nil
      if ['?', 'help'].include?(name)
        process_help parameter
        return
      end
      if @commands[name]
        @commands[name].execute parameter
      else
        @io.say "unknown command \"#{name}\""
      end
    end
  end
end