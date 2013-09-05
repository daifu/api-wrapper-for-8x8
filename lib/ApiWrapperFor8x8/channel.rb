module ApiWrapperFor8x8
  module Channel

    # Get a list of channels
    #
    def channel_list(filtered_options={})
      get "/stats/channels.json", {}, filtered_options
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
    #
    # Ex. Get a sum of 'accepted-count' from channel_id: 1, date range
    # , filtered_options, and queue-name
    # @api_connection.channel_sum_x('accepted-count',
    #                               1,
    #                               {:d => '2013-09-04T00:00:00-07:00,2013-09-04T23:59:59-07:00'},
    #                               {"agent-id"=>"foo", "queue-name"=>"bar"}}
    def channel_sum_x(x, guid=0,  params_options={}, filtered_options={})
      details = channel_details(guid, params_options, filtered_options)
      sum = details.map {|detail| detail[x]}.inject(:+) if details
      sum || 0
    end

  end
end
