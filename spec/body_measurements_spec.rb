require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }

  describe '#fat_on_date' do
    it 'gets fat on date'
  end

  describe '#fat_for_range' do
    it 'gets fat for range'
  end

  describe '#fat_for_period' do
    it 'gets fat for period'
  end

  describe '#body_goal' do
    it 'gets daily body goals'
    it 'gets weekly body goals'
    it 'raises exception if goal type is not valid'
  end

  describe '#weight_on_date' do
    it 'gets weight on date'
  end

  describe '#weight_for_period' do
    it 'gets weight for period'
  end

  describe '#weight_for_range' do
    it 'gets weight for range'
  end

end
