$: << File.dirname(__FILE__)+'/../lib'

require 'shell_shock/context'

RSpec.configure do |config|
  config.mock_framework = :rspec
end