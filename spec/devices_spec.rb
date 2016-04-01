require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }

  describe '#devices' do
    it 'gets all devices'
  end

  describe '#alarms' do
    it 'gets all alarms'
  end
end