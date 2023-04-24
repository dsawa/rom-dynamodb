unless ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.project_name 'rom-dynamodb'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "securerandom"
require "transproc/all"
require "factory_bot"
require "faker"
require 'aws-sdk-dynamodb'
require "rom/dynamodb"
require 'pry'

Dir[Pathname(__FILE__).dirname.join('shared/*.rb').to_s].each { |f| require f }

Dir[Pathname(__FILE__).dirname.join('factories/*.rb').to_s].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
