require 'spec_helper'

describe ApiWrapperFor8x8::Agents do
  describe "agent_list" do
    it "should GET /stats/agents.json" do
      @api.should_receive(:get).with('/stats/agents.json', {})
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
      expect(@api).to receive(:filtered_agents).with(agents, {}).and_return(agents)
      expect(@api).to receive(:agent_list).with({}).and_return(agents)
      expect(@api).to receive(:agent_detail).with(agent_id, {}).and_return(agent_details)
      @api.agents_detail.should == agent_details
    end
  end

  describe "filtered_agents" do
    before :each do
      @agent1 = {"agent-id" => "a", "enabled" => 'Y'}
      @agent2 = {"agent-id" => 'b', "enabled" => 'D'}
      @agent_lists = [@agent1, @agent2]
    end
    it "should filter agents with enabled" do
      @api.filtered_agents(@agent_lists, {"enabled" => "Y"}).should == [@agent1]
      @api.filtered_agents(@agent_lists, {"enabled" => "D"}).should == [@agent2]
    end
  end
end
