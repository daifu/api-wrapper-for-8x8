require 'spec_helper'

describe ApiWrapperFor8x8::Connection do
  before do
    @net_http_response = Net::HTTPOK.new('1.1', 200, 'OK')
    @net_http_response.stub(:body => '')
    @httparty_response = double("HTTPartyResponse", :parsed_response => nil, :body => '', :success? => true)
  end
  describe "GET" do
    describe "connection method" do
      it "should have valid key tokens" do
        @api.api_token_keys_valid?.should == true
      end

      it "should have invalid key tokens" do
        @conn = ApiWrapperFor8x8::Connection.new({:username => '', :password => nil})
        @conn.api_token_keys_valid?.should == false
      end
    end

    it "should get /stats/agents.json" do
      @api.should_receive(:request).with(:get, "/stats/agents.json", {}).and_return(@net_http_response)
      @api.get('/stats/agents.json')
    end

  end
end
