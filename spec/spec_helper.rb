require 'rubygems'
require 'rspec'
require 'bundler/setup'
require 'rspec/expectations'

require_relative '../lib/ApiWrapperFor8x8/connection.rb'

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    @api = ApiWrapperFor8x8::Connection.new({:api_un => ENV['PHONE_SYSTEM_UN'], :api_token => ENV['PHONE_SYSTEM_TOKEN']})
  end
end
