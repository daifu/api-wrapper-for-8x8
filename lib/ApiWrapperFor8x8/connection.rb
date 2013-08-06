require 'httparty'

module ApiWrapperFor8x8
  class Connection
    include HTTParty
    base_uri ENV['PHONE_SYSTEM_URL']
    format :json

    def initialize(creds={})
      @configuration = {}
      ApiWrapperFor8x8::Connection.api_token_keys.each do |key|
        @configuration[key] = creds[key].to_s
      end
    end

    def request(method, url, options={})
      raise "Please set api_token" unless api_token_keys_valid?
      self.class.__send__(method, url, options)
    end

    def api_token_keys_valid?
      return ApiWrapperFor8x8::Connection.api_token_keys.detect {|key| @configuration[key] == ''} == nil
    end

    def self.api_token_keys
      [:username, :password].freeze
    end

    def get(url)
      request('get', url)
    end
  end
end