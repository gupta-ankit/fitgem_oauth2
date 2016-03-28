require 'spec_helper'

describe FitgemOauth2::Client do

  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }
  let(:subscription_id) { 'xyz' }

  let(:subscriptions) { {} }

  describe '#subscriptions' do

    it 'gets all subscriptions' do
      url = "1/user/#{user_id}/apiSubscriptions.json"
      expect(client).to receive(:get_call).with(url).and_return(subscriptions)
      expect(client.subscriptions(type: :all)).to eql(subscriptions)
    end

    it 'gets sleep subscriptions' do
      url = "1/user/#{user_id}/sleep/apiSubscriptions.json"
      expect(client).to receive(:get_call).with(url).and_return(subscriptions)
      expect(client.subscriptions(type: :sleep)).to eql(subscriptions)
    end

    it 'gets subscriptions by id' do
      url = "1/user/#{user_id}/apiSubscriptions/#{subscription_id}.json"
      expect(client).to receive(:get_call).with(url).and_return(subscriptions)
      expect(client.subscriptions(subscription_id: subscription_id)).to eql(subscriptions)
    end
  end

  describe '#create_subscription' do

    it 'creates a subscription to all' do
      url = "1/user/#{user_id}/apiSubscriptions/#{subscription_id}.json"
      expect(client).to receive(:post_call).with(url).and_return(subscriptions)
      expect(client.create_subscription(subscription_id: subscription_id)).to eql(subscriptions)
    end

    it 'creates a subscription to a type' do
      url = url = "1/user/#{user_id}/sleep/apiSubscriptions/#{subscription_id}.json"
      expect(client).to receive(:post_call).with(url).and_return(subscriptions)
      expect(client.create_subscription(type: :sleep, subscription_id: subscription_id)).to eql(subscriptions)
    end
  end

  describe '#remove_subscription' do

    it 'creates a subscription to all' do
      url = "1/user/#{user_id}/apiSubscriptions/#{subscription_id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(subscriptions)
      expect(client.remove_subscription(subscription_id: subscription_id)).to eql(subscriptions)
    end

    it 'creates a subscription to a type' do
      url = url = "1/user/#{user_id}/sleep/apiSubscriptions/#{subscription_id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(subscriptions)
      expect(client.remove_subscription(type: :sleep, subscription_id: subscription_id)).to eql(subscriptions)
    end
  end

end