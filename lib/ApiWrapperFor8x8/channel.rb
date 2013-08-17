module ApiWrapperFor8x8
  module Channel

    def channel_list(options={})
      get "/stats/channels.json", options
    end

    def channel_details(guid, options)
      get "/stats/channels/#{guid}/statistics.json", options
    end

  end
end
