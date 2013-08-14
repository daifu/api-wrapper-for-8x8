require 'rubygems'
require 'rspec'
require 'bundler/setup'
require 'rspec/expectations'

require_relative '../lib/ApiWrapperFor8x8/connection.rb'

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    @api = ApiWrapperFor8x8::Connection.new({:username => ENV['PHONE_SYSTEM_UN'], :password => ENV['PHONE_SYSTEM_TOKEN']})
  end
end
