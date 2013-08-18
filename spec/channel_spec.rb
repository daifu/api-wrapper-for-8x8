require 'spec_helper'

describe ApiWrapperFor8x8::Channel do
  describe "channel_list" do

    it "should GET /stats/channels.json" do
      @api.should_receive(:get).with('/stats/channels.json', {})
      @api.channel_list
    end

    context "GET channel statistics" do
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
        mock = {'statistics' => {'statistic' => [{'accepted-count' => 3, 'enter-count' => 10}]}}
        filters = ['accepted-count']
        @api.stub(:get => mock)
        details = @api.channel_details(1, {}, filters)
        details.each do |detail|
          detail.should_not be_nil
          detail.size.should == filters.size
          filters.each do |filter|
            detail.should_has_key filter
          end
        end
      end
    end

  end
end
