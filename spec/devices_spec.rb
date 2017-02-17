require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  describe '#devices' do
    it 'gets all devices' do
      url = "user/#{user_id}/devices.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.devices).to eql(response)
    end
  end

  describe '#alarms' do
    it 'gets all alarms' do
      tracker_id = random_sequence
      url = "user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json"
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.alarms(tracker_id)).to eql(response)
    end
  end

  describe '#add_alarm' do
    it 'adds alarm' do
      tracker_id = random_sequence
      url = "user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json"
      params = random_sequence
      response = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.add_alarm(tracker_id, params)).to eql(response)
    end
  end

  describe '#update_alarm' do
    it 'updates alarm' do
      tracker_id = random_sequence
      params = random_sequence
      response = random_sequence
      alarm_id = random_sequence
      url = "user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_alarm(tracker_id, alarm_id, params)).to eql(response)
    end
  end

  describe '#remove_alarm' do
    it 'removes alarm' do
      tracker_id = random_sequence
      response = random_sequence
      alarm_id = random_sequence
      url = "user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.remove_alarm(tracker_id, alarm_id)).to eql(response)
    end
  end
end