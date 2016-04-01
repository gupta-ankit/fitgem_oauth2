require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }

  describe '#devices' do
    it 'gets all devices'
  end

  describe '#alarms' do
    it 'gets all alarms'
  end

  describe '#add_alarm' do
    it 'adds alarm'
  end

  describe '#update_alarm' do
    it 'updates alarm'
  end

  describe '#remove_alarm' do
    it 'removes alarm'
  end
end