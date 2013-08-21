require 'spec_helper'

describe ApiWrapperFor8x8::Channel do
  describe "channel_list" do

    before :each do
      @resp = {'statistics' => {'statistic' => [{'accepted-count' => 3, 'entered-count' => 10, 'queue-name' => 'inbound'}, {'accepted-count' => 2, 'entered-count' => 5, 'queue-name' => 'outbound'}]}}
      @filters = ['accepted-count']
    end

    it "should GET /stats/channels.json" do
      @api.should_receive(:get).with('/stats/channels.json', {})
      @api.channel_list
    end

    context "GET channel_details statistics" do
      it "should GET /stats/channels/guid/statistics.json without options" do
        @api.should_receive(:get).with('/stats/channels/1/statistics.json', {})
        @api.channel_details(1, {})
      end

      it "should GET channel details with date range" do
        date_range = {:d => Time.now.iso8601+','+(Time.now-3600).iso8601}
        @api.should_receive(:get).with('/stats/channels/1/statistics.json', date_range)
        @api.channel_details(1, date_range)
      end

      it "should GET more than 50 records for channel details" do
        @api.stub(:size_of => ApiWrapperFor8x8::Channel::RECORDS_LIMIT+1)
        @api.should_receive(:get).exactly(ApiWrapperFor8x8::Channel::MAX_TRY).and_return(@net_http_response)
        @api.channel_details(1)
      end

      it "should GET filtered channel details with filter options" do
        expect(@api).to receive(:get).with('/stats/channels/0/statistics.json', {}).and_return(@resp)
        # mock
        details = @api.channel_details(0, {}, @filters)
        details.size.should > 0
        details.each do |detail|
          detail.should_not be_nil
          detail.size.should == @filters.size
          @filters.each do |filter|
            detail.should have_key(filter)
          end
        end
      end
    end

    context "channel_sum_x" do
      before :each do
        expect(@api).to receive(:get).with('/stats/channels/0/statistics.json', {}).and_return(@resp)
      end
      it "should Get the sum of x" do
        sum = @api.channel_sum_x('accepted-count')
        sum.should == 5
      end

      it "should Get the sum of x with restriction" do
        sum = @api.channel_sum_x('accepted-count', {'queue-name' => 'inbound'})
        sum.should == 3
      end
    end


  end
end
