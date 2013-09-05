module ApiWrapperFor8x8
  module Agents
    include ApiWrapperFor8x8::Agent

    # Get a list of all the agents
    #
    def agent_list(filtered_options={})
      get('/stats/agents.json', {}, filtered_options)
    end

    # Get all the details of agents
    #
    # Ex. Get details for date range of '2013-09-04T00:00:00-07:00,2013-09-04T23:59:59-07:00'
    # and filtered with queue-name and agent-id
    # @api_connection.agents_detail({:d => '2013-09-04T00:00:00-07:00,2013-09-04T23:59:59-07:00'},
    #                               {"agent-id"=>"foo", "queue-name"=>"bar"})
    def agents_detail(params={}, filtered_options={})
      details = []
      agent_list.each do |agent|
        details.concat(agent_detail(agent['agent-id'], params, filtered_options))
      end
      details
    end
  end
end
