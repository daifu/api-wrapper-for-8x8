require 'spec_helper'

describe "ApiWrapperFor8x8::Stats" do
  describe "stats_per_hour" do

    context "should return correct data with valid params" do
      before :each do
        @url    = "/stats/channels/1/statistics.json"
        @params = {:d => '2013-05-28T12:54:55-07:00,2013-05-28T19:54:55-07:00', :tz => 'America/Los_Angeles'}
        @resp   = [{"time-stamp" => "2013-05-28T13:30:00-07:00",
                    "entered-count"   => 3,
                    "accepted-count"  => 2,
                    "abandoned-count" => 1,
                    "time-waiting"    => 24
                  },{"time-stamp"  => "2013-05-28T14:00:00-07:00",
                    "entered-count"   => 10,
                    "accepted-count"  => 8,
                    "abandoned-count" => 2,
                    "time-waiting"    => 124},
                   {"time-stamp"      => "2013-05-28T19:00:00-07:00",
                    "entered-count"   => 20,
                    "accepted-count"  => 19,
                    "abandoned-count" => 1,
                    "time-waiting"    => 144}]
      end

      it "should return an array of hash that includes all the stat attr and the timestamp" do
        expect(@api).to receive(:get).with(@url, @params, {}).and_return(@resp)
        ret = @api.stats_per_hour(@url, @params, {})

        ret.size.should == 9
        ret.map {|r| r['entered-count']}.inject {|sum,num| sum+num}.should == 33
        ret.map {|r| r['accepted-count']}.inject {|sum,num| sum+num}.should == 29
        ret.map {|r| r['abandoned-count']}.inject {|sum,num| sum+num}.should == 4
      end
    end

  end
end
