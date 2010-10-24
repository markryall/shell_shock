module ShellShock
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
        puts "unknown command \"#{command_name}\""
      end
    end
  end
end