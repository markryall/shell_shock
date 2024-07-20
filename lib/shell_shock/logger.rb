# frozen_string_literal: true

module ShellShock
  module Logger
    def log(message = nil)
      return unless ENV["LOG_PATH"]

      File.open(ENV.fetch("LOG_PATH", nil), "a") do |file|
        file.puts message if message
        file.puts yield if block_given?
      end
    end
  end
end
