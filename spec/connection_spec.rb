require 'spec_helper'

describe ApiWrapperFor8x8::Connection do
  before do
    @net_http_response = Net::HTTPOK.new('1.1', 200, 'OK')
    @net_http_response.stub(:body => '{}')
    @httparty_response = double("HTTPartyResponse", :parsed_response => {}, :body => '{}', :success? => true)
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

      it "should have incorrect url" do
        url = "/stats/agent.json"
        lambda {
          @api.validate_and_extract_url(url)
        }.should raise_error(ApiWrapperFor8x8::ResponseError)
      end

      it "should have correct url" do
        urls = ["/stats/agents.json", "/stats/channels.json", "/stats/statistics.json"]
        urls.each do |url|
          @api.validate_and_extract_url(url).size.should > 0
        end
      end
    end

    describe "get_stat" do
      before :each do
        expect(@api).to receive(:validate_and_extract_url).with('').and_return('statistics')
        @resp1 = {'statistics' => {'statistic' => []}}
        @resp2 = {'statistics' => {'statistic' => [{}, {}]}}
      end

      it "should get empty stat" do
        @api.get_stat(@resp1, '').should == []
      end

      it "should get correct stat" do
        @api.get_stat(@resp2, '').should == [{}, {}]
      end
    end

    describe "get" do
      it "should have more than 50 records from the response" do
        @api.stub(:request)
        @api.stub(:parsed_response)
        url    = '/stats/channels/1/statistics.json'
        params = {:n => 1}
        expect(@api).to receive(:get_stat).exactly(ApiWrapperFor8x8::Connection::MAX_TRY)
                        .and_return([{}]*(ApiWrapperFor8x8::Connection::RECORDS_LIMIT))
        @api.get(url, {:n => 1}).size.should == ApiWrapperFor8x8::Connection::RECORDS_LIMIT * ApiWrapperFor8x8::Connection::MAX_TRY
      end
    end

    describe "apply_filter" do
      before :each do
        @resp = [{'accepted-count' => 3, 'entered-count' => 10, 'queue-name' => 'inbound'}, {'accepted-count' => 2, 'entered-count' => 5, 'queue-name' => 'outbound'}]
        @filters = {'queue-name' => 'inbound'}
      end
      context "with filter options" do
        it "should gat a list of hash that meet the filter options" do
          list = @api.apply_filter(@resp, @filters)
          list.size.should == 1
          list[0]['queue-name'].should == 'inbound'
        end
      end

      context "without filter option" do
        it "should get a list of original hash" do
          list = @api.apply_filter(@resp, {})
          list.size.should == @resp.size
        end
      end
    end

    describe "base_uri" do
      it "should not be empty or nil" do
        ApiWrapperFor8x8::Connection::base_uri.should_not be_nil
        ApiWrapperFor8x8::Connection::base_uri.size.should_not be_zero
      end
    end

  end
end
