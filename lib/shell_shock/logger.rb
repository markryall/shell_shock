module ShellShock
    module Logger
    def log message
      return unless ENV['LOG_PATH']
      File.open(ENV['LOG_PATH'], 'a') do |file|
        file.puts message
      end
    end
  end
end