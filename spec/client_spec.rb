# frozen_string_literal: true

require 'spec_helper'

describe FitgemOauth2::Client do
  let(:client_id) { '22942C' }
  let(:client_secret) { 'secret' }
  let(:token) do
    'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzAzNDM3MzUsInNjb3BlcyI6Indwcm8gd2xvYyB3bnV0IHdzbGUgd3NldCB3' \
    'aHIgd3dlaSB3YWN0IHdzb2MiLCJzdWIiOiJBQkNERUYiLCJhdWQiOiJJSktMTU4iLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOi' \
    'JhY2Nlc3NfdG9rZW4iLCJpYXQiOjE0MzAzNDAxMzV9.z0VHrIEzjsBnjiNMBey6wtu26yHTnSWz_qlqoEpUlpc'
  end
  let(:user_id) { '26FWFL' }
  let(:unit_system) { 'en_US' }
  let(:client) { FitgemOauth2::Client.new(opts) }

  let(:opts) do
    {client_id: client_id, client_secret: client_secret, token: token, user_id: user_id, unit_system: unit_system}
  end

  describe '#initialize' do
    it 'succeeds' do
      expect(client.client_id).to eq(client_id)
      expect(client.client_secret).to eq(client_secret)
      expect(client.token).to eq(token)
      expect(client.user_id).to eq(user_id)
      expect(client.unit_system).to eq(unit_system)
    end

    it 'defaults user_id' do
      opts.delete(:user_id)
      expect(client.user_id).to eq(FitgemOauth2::Client::DEFAULT_USER_ID)
    end

    it 'defaults unit system' do
      opts.delete(:unit_system)
      expect(client.unit_system).to be_nil
    end

    it 'raises an error if client_id is missing' do
      opts.delete(:client_id)
      expect { client }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end

    it 'raises an error if client_secret is missing' do
      opts.delete(:client_secret)
      expect { client }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end

    it 'raises an error if token is missing' do
      opts.delete(:token)
      expect { client }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end
  end

  describe 'handling fitbit API status codes' do
    it 'raises ApiLimitReachedError when Fitbit API returns 429' do
      url = "https://api.fitbit.com/1/user/#{user_id}/activities/date/#{client.format_date(Date.today)}.json"
      stub_request(:any, url)
        .to_return(status: 429)
      expect { client.daily_activity_summary(Date.today) }.to raise_error(FitgemOauth2::ApiLimitError)
    end
  end
end
