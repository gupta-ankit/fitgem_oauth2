# frozen_string_literal: true

require 'spec_helper'

describe FitgemOauth2::Client do
  describe '#user_info' do
    it 'returns user info' do
      response = random_sequence
      client = FactoryBot.build(:client)
      user_id = client.user_id
      expect(client).to receive(:get_call).with("user/#{user_id}/profile.json").and_return(response)
      expect(client.user_info).to eq(response)
    end
  end
end
