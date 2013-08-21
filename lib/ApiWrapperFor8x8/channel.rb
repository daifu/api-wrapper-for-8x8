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
        details.concat(get_stat(details_tmp)) if details_tmp
        details = filter(details, filter_options) if filter_options.size > 0
        tries += 1
      end while size_of(details_tmp) >= RECORDS_LIMIT &&
                tries <= MAX_TRY
      details
    end

    # It is easier for geting the sum of a value from the
    # an array of records with the restriction you can set
    def channel_sum_x(x, restriction={},  guid=0,  params_options={}, filter_options=[])
      details = channel_details(guid, params_options, filter_options)
      details = restrict(details, restriction) if restriction.size > 0
      sum = details.map {|detail| detail[x]}.inject(:+) if details
      sum || 0
    end

    private
    def restrict(details, restriction)
      details.select do |detail|
        flag = true
        restriction.each do |key, value|
          if detail[key] != value
            flag = false
          end
        end
        flag
      end
    end

    def filter(details, criteria)
      details.each do |detail|
        detail.select! { |key, value| criteria.include?(key) }
      end
      details
    end

    def size_of(details)
      details ||= []
      details.size
    end

    def get_stat(resp)
      # can be cahnged based on the api
      resp['statistics']['statistic']
    end

  end
end
