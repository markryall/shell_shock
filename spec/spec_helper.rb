# frozen_string_literal: true

$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require "shell_shock/context"
require "shell_shock/command_spec"

RSpec.configure do |config|
  config.mock_framework = :rspec
end
