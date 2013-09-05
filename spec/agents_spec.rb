require 'spec_helper'

describe ApiWrapperFor8x8::Agents do
  describe "agent_list" do
    it "should GET /stats/agents.json" do
      @api.should_receive(:get).with('/stats/agents.json', {}, {})
      @api.agent_list
    end
  end

  describe "agents_detail" do
    it "should receive an array of agent with their details" do
      agent_id = 'agentId'
      agents   = [{'agent-id' => agent_id}]
      resp     = {'statistics' => {'statistic' => agents}}
      agent_details = [{'agent-id' => agent_id, 'accepted-count' => 23}]
      @api.stub(:agent_list)
      expect(@api).to receive(:agent_list).and_return(agents)
      expect(@api).to receive(:agent_detail).with(agent_id, {}, {}).and_return(agent_details)
      @api.agents_detail.should == agent_details
    end
  end
end
