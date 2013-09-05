require 'spec_helper'

describe ApiWrapperFor8x8::ResponseError do
  describe "For OAth response" do
    before do
      @net_http_response = Net::HTTPSuccess.new('1.1', '200', 'OK')
      @error = ApiWrapperFor8x8::ResponseError.new(@net_http_response)
    end

    it "response should return Net::HTTP response" do
      @error.response.should == @net_http_response
    end

    it "code should return response code" do
      @error.code.should == '200'
    end

    describe "message" do
      it "should return response message" do
        @error.message.should == 'OK'
      end

      it "should return specified message" do
        error = ApiWrapperFor8x8::ResponseError.new(@net_http_response, "No way")
        error.message.should == 'No way'
      end
    end


    describe "common_solutions" do
      describe "on 401" do
        it "should suggest to check credentials" do
          net_http_response = Net::HTTPUnauthorized.new('1.1', '401', 'Unauthorized Access')
          error = ApiWrapperFor8x8::ResponseError.new(net_http_response)
          error.common_solutions.should match /Check your credentials/i
        end
      end
    end
  end
end
