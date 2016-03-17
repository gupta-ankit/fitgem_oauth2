require 'spec_helper'

describe FitgemOauth2::Client do
  before do
    @client = FitgemOauth2::Client.new({
      client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      token: ENV['token']
    })
  end

  describe "activities in time period" do
    it "raises an exception if time period is not specified" do
      pending "Not yet implemented"
    end

    it "raises an exception if resource path is not specified" do
      pending "Not yet implemented"
    end
  end
end
