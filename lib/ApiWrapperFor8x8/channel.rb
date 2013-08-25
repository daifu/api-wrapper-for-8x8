module ApiWrapperFor8x8
  module Channel

    def channel_list(options={})
      get "/stats/channels.json", options
    end

    # Get one details on the channel
    # guid: the id of the channel
    # options: {
    #   'd'  => date range
    #   'tz' => time zone
    #   'media-type' => {media-type, including T, }
    #   'n'  => {offset} limited 50 records per request,
    #   'queue-id' => {queue-id for agent for query variables}
    # }
    # filter_options is to filtered out the attributes from the object
    def channel_details(guid, params_options={}, filtered_options={})
      get("/stats/channels/#{guid}/statistics.json", params_options, filtered_options)
    end

    # It is easier for geting the sum of a value from the
    # an array of records with the restriction you can set
    def channel_sum_x(x, guid=0,  params_options={}, filtered_options={})
      details = channel_details(guid, params_options, filtered_options)
      sum = details.map {|detail| detail[x]}.inject(:+) if details
      sum || 0
    end

  end
end
