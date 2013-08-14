require 'spec_helper'

describe ApiWrapperFor8x8::Connection do
  before do
    @net_http_response = Net::HTTPOK.new('1.1', 200, 'OK')
    @net_http_response.stub(:body => '')
    @api.stub(:request => nil)
    @httparty_response = stub("HTTPartyResponse", :parsed_response => nil, :body => '', :success? => true)
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
      @api.get('/stats/agents.json').should_receive(:request).and_return(@net_http_response)
    end
  end
end
