module ApiWrapperFor8x8
  module Agents
    include ApiWrapperFor8x8::Agent

    def agent_list(params={})
      get('/stats/agents.json', params)
    end

    def agents_detail(params={}, filtered_options={})
      details = []
      filtered_agents(agent_list, filtered_options).each do |agent|
        details << agent_detail(agent['agent-id'], params)
      end
      details.flatten
    end

    def filtered_agents(agent_list, filtered_options)
      if filtered_options.size == 0
        return agent_list
      end
      agent_list.select do |agent|
        flag = true
        filtered_options.each do |key, value|
          flag = false unless (agent[key] && agent[key] == value)
        end
        flag
      end
    end

  end
end
