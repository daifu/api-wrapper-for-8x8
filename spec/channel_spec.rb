require 'spec_helper'

describe ApiWrapperFor8x8::Channel do
  before :each do
    @resp = [{'accepted-count' => 3, 'entered-count' => 10, 'queue-name' => 'inbound'}, {'accepted-count' => 2, 'entered-count' => 5, 'queue-name' => 'outbound'}]
    @filters = {'queue-name' => 'inbound'}
  end

  describe "channel_list" do
    it "should GET /stats/channels.json" do
      @api.should_receive(:get).with('/stats/channels.json', {}, {})
      @api.channel_list
    end

  end

  describe "GET channel_details statistics" do
    it "should GET /stats/channels/guid/statistics.json without options" do
      @api.should_receive(:get).with('/stats/channels/1/statistics.json', {}, {})
      @api.channel_details(1)
    end

    it "should GET channel details with date range" do
      date_range = {:d => Time.now.iso8601+','+(Time.now-3600).iso8601}
      @api.should_receive(:get).with('/stats/channels/1/statistics.json', date_range, {})
      @api.channel_details(1, date_range)
    end
  end

  describe "channel_sum_x" do
    before :each do
      expect(@api).to receive(:get).with('/stats/channels/0/statistics.json', {}, {}).and_return(@resp)
    end

    it "should Get the sum of x" do
      sum = @api.channel_sum_x('accepted-count')
      sum.should == 5
    end
  end
end
