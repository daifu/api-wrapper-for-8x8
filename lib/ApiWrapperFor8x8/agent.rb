module ApiWrapperFor8x8
  module Agent

    def agent_detail(id, params, filtered_options)
      get("/stats/agents/#{id}/statistics.json", params, filtered_options)
    end

  end
end
