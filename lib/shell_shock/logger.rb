module ShellShock
    module Logger
    def log message=nil
      return unless ENV['LOG_PATH']
      File.open(ENV['LOG_PATH'], 'a') do |file|
        file.puts message if message
        file.puts yield if block_given?
      end
    end
  end
end