require 'spec_helper'

describe 'Agent' do
  describe "get_detail" do
    it "should have call get with correct params" do
      id = 0
      expect(@api).to receive(:get).with("/stats/agents/#{id}/statistics.json", {}, {})
      @api.agent_detail(id, {}, {})
    end
  end
end
