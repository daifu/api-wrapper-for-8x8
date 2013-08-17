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
    end

  end
end
