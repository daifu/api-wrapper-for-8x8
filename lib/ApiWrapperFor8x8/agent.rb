module ApiWrapperFor8x8
  module Agent

    def agent_detail(id, params)
      get("/stats/agents/#{id}/statistics.json", params)
    end

  end
end
