require 'rubygems'
require 'rawline'
require 'active_support/inflector'

module ShellShock
  module Context
    def refresh
      refresh_commands if respond_to?(:refresh_commands)
      @editor.completion_proc = lambda do |word|
        words = @editor.line.words
        if words.first
          command = @commands[words.first]
          if command and command.respond_to?(:completion)
            rest = words.slice(1..-1)
            rest ||= []
            return command.completion(rest.join(' '))
          end
        end

        @commands.keys.grep( /^#{Regexp.escape(word)}/ ).sort
      end
    end

    def push
      @editor = RawLine::Editor.new
      @editor.bind(:ctrl_d) { return }
      refresh
      begin
        while line = @editor.read(@prompt_text, true)
          line.strip!
          case line
            when /^\?$/
              process_help 
            when /^\? (.*)/
              process_help $1
            when /^(\w+) (.*)/
              return if ['quit', 'exit'].include?($1)
              process_command $1, $2
            when /^(\w+)/
              return if ['quit', 'exit'].include?($1)
              process_command $1
            else
              puts 'unknown command'
          end
          puts
          refresh
        end
      rescue Interrupt => e
        return
      end
      puts
    end

    def display_help_for_command command_name
      command = @commands[command_name]
      if command
        @io.say "Command \"#{command_name}\""
        @io.say "Usage: #{command_name} #{command.usage}" if command.respond_to?(:usage)
        @io.say "Help:\n #{command.help}" if command.respond_to?(:help)      
      else
        puts 'unknown command'
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
        @io.say 'unknown command'
      end
    end
  end
end