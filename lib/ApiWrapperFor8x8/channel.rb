module ApiWrapperFor8x8
  module Channel

    RECORDS_LIMIT = 50
    MAX_TRY       = 3

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
    def channel_details(guid, params_options={}, filter_options=[])
      details = []
      tries   = 1
      begin
        details_tmp = get("/stats/channels/#{guid}/statistics.json", params_options)
        details << details_tmp['statistics']['statistic'] if details_tmp
        details = filter(details, filter_options) if filter_options.size > 0
        tries += 1
      end while size_of(details_tmp) >= RECORDS_LIMIT &&
                tries <= MAX_TRY
      details
    end

    def filter(details, criteria)
      details.map do |detail|
      end
    end

    def size_of(details)
      details ||= []
      details.size
    end

  end
end
