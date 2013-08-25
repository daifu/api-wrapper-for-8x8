module ApiWrapperFor8x8
  class ResponseError < Exception
    attr_reader :response

    def initialize(response, message=nil)
      self.set_backtrace(caller[1..-1]) if self.backtrace.nil?
      @response = response
      super((message || @response.message))
    end

    def code
      @response.code
    end

    def common_solutions
      if @response.code.to_i == 401
        "Check your credentials and make sure they are correct and not expired"
      end
    end

    def detailed_message
      if @response.is_a? Hash
        @response[:error][:message] if @response[:error]
      end
    end
  end
end
