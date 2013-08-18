require 'rubygems'
require 'rspec'
require 'bundler/setup'
require 'rspec/expectations'
require 'httparty'
require 'json'

Dir[File.dirname(__FILE__)+'/../lib/ApiWrapperFor8x8/*.rb'].each{|file| require file}

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    @api = ApiWrapperFor8x8::Connection.new({:username => ENV['PHONE_SYSTEM_UN'], :password => ENV['PHONE_SYSTEM_TOKEN']})
  end
end
