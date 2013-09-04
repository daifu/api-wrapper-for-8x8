module ApiWrapperFor8x8
  module Stats

    DEFAULT_STAT_ATTR = ["entered-count", "accepted-count", "abandoned-count", "time-waiting"]
    # Since the api only aggregate the records by half an
    # hour, so why not they have aggregate by hour
    def stats_per_hour(url, params={}, filtered_opts={}, stats_attr=[])
      raise ApiWrapperFor8x8::ResponseError.new({}, "Required date range!") unless params[:d]
      if stats_attr.include?('queue-name') || stats_attr.include?('time-stamp')
        raise ApiWrapperFor8x8::ResponseError.new({}, "Does not support queue-name or time-stamp as stat attribute")
      end

      stats = get(url, params, filtered_opts)
      stats_attr = DEFAULT_STAT_ATTR if stats_attr.size == 0
      times = params[:d].split(',')
      start = Time.parse(times.first)
      stop  = Time.parse(times.last)
      hash = {}

      # init the hash object
      (beginning_of_hour(start).to_i..end_of_hour(stop).to_i).step(3600) do |h|
        hour     = Time.at(h)
        hour_key = hour.iso8601
        hash[hour_key] = {}
        hash[hour_key]['timestamp'] = hour
        stats_attr.each { |key| hash[hour_key][key] = 0 }
      end

      # insert stats data to hash with timestamp as key
      stats.each do |stat|
        timestamp = stat["time-stamp"]
        timekey = hash[timestamp] ? timestamp : (Time.parse(timestamp) - 1800).iso8601
        stats_attr.each do |stat_attr|
          stats_by_time = hash[timekey] || {}
          stats_by_time[stat_attr] += stat[stat_attr] if stats_by_time[stat_attr] && stat[stat_attr]
        end
      end if stats
      return hash.collect{ |key, value| value }
    end

    def beginning_of_hour(time)
      Time.mktime(time.year, time.month, time.day, time.hour).send(Time.now.gmt? ? :gmt : :localtime)
    end

    def end_of_hour(time)
      beginning_of_hour(time)+3600
    end

  end
end
