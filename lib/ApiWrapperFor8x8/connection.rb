module ApiWrapperFor8x8
  class Connection
    include HTTParty

    include ApiWrapperFor8x8::Channel
    include ApiWrapperFor8x8::Agents
    include ApiWrapperFor8x8::Stats

    RECORDS_LIMIT = 50
    MAX_TRY       = 3
    VALID_SEGMENT = ['channels', 'agents', 'statistics']

    API_URI_REGEX = /^https?:\/\/.+\.(mycontactual|8x8).com\/api/

    DEFAULT_BASE_URI = "https://na3.mycontactual.com/api"

    format :json

    def initialize(creds={}, api_uri = DEFAULT_BASE_URI)
      @configuration = {}
      ApiWrapperFor8x8::Connection.api_token_keys.each do |key|
        @configuration[key] = creds[key].to_s
      end
      self.class.base_uri api_uri
    end

    def request(method, url, options={})
      unless api_token_keys_valid?
        raise ApiWrapperFor8x8::ResponseError.new(nil, "Please set username and password correctly")
      end
      unless api_uri_valid?
        raise ApiWrapperFor8x8::ResponseError.new(nil, "Please set a valid API destination")
      end
      options[:basic_auth] = @configuration
      parsed_response(self.class.__send__(method, url, options))
    end

    def api_token_keys_valid?
      return ApiWrapperFor8x8::Connection.api_token_keys.detect {|key| @configuration[key] == ''} == nil
    end

    def api_uri_valid?
      return self.class.base_uri.match(API_URI_REGEX).present?
    end

    def self.api_token_keys
      [:username, :password].freeze
    end

    def get(url, params={}, filtered_opts={})
      offset = params[:n] || 1
      params[:n] = offset unless params[:n]

      unless params.empty?
        url = "#{url}?#{serialize_param(params)}"
      end

      tries  = 1
      resp   = []
      begin
        resp_tmp = get_stat(request(:get, url, {}), url)
        resp.concat(apply_filter(resp_tmp, filtered_opts)) if resp_tmp
        tries += 1

        # update the url to increase the offset
        offset += RECORDS_LIMIT
        url.gsub!(/n=[0-9]*/, "n=#{offset}")
      end while (size_of(resp_tmp) >= RECORDS_LIMIT && tries <= MAX_TRY)
      resp
    end

    def serialize_param(params)
      params.sort.map {|key, value| URI.escape("#{key}=#{value}")}.join('&')
    end

    def size_of(details)
      details ||= []
      details.size
    end

    def validate_and_extract_url(url)
      uri = URI(url)
      last_seg = uri.path.split('/').last
      if last_seg =~ /(#{VALID_SEGMENT.join('|')})\.json$/
        return last_seg.split('.').first
      else
        raise ApiWrapperFor8x8::ResponseError.new(nil, "URL path is incorrect! please double check your url.")
      end
    end

    def get_stat(resp, url)
      if root_name = validate_and_extract_url(url)
        return [] if (resp && resp.size == 0)
        return resp[root_name][root_name[0...-1]]
      end
    end

    def apply_filter(list, filtered_options)
      if filtered_options.size == 0
        return list
      end
      list.select do |ele|
        flag = true
        filtered_options.each do |key, value|
          flag = false unless (ele[key] && ele[key] == value)
        end
        flag
      end
    end

    def parsed_response(response)
      if response.is_a? Net::HTTPResponse
        unless response.is_a? Net::HTTPSuccess
          raise ApiWrapperFor8x8::ResponseError.new(response)
        end
        JSON.parse(response.body)
      else
        unless response.success?
          raise ApiWrapperFor8x8::ResponseError.new(response)
        end
        response.parsed_response
      end
    end
  end
end
