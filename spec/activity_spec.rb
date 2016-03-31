require 'spec_helper'

describe FitgemOauth2::Client do

  let( :client_id ) { '22942C' }
  let( :client_secret ) { 'secret' }
  let( :token ) { 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzAzNDM3MzUsInNjb3BlcyI6Indwcm8gd2xvYyB3bnV0IHdzbGUgd3NldCB3aHIgd3dlaSB3YWN0IHdzb2MiLCJzdWIiOiJBQkNERUYiLCJhdWQiOiJJSktMTU4iLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0MzAzNDAxMzV9.z0VHrIEzjsBnjiNMBey6wtu26yHTnSWz_qlqoEpUlpc' }

  before do
    @client = FitgemOauth2::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      token: token
    )
  end

  describe "activities in time period" do
    it "raises an exception if time period is not specified"

    it "raises an exception if resource path is not specified"
  end
end
