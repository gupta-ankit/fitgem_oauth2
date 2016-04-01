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

  describe '#log_body_fat' do
    it 'logs body fat'
  end

  describe '#delete_logged_body_fat' do
    it 'deletes logged body fat'
  end

  describe '#get_body_time_series' do
    it 'gets body time series'
  end

  #=================
  # Goals
  #==================

  describe '#body_goal' do
    it 'gets daily body goals'
    it 'gets weekly body goals'
    it 'raises exception if goal type is not valid'
  end

  describe '#update_body_fat_goal' do
    it 'updates body fat goal'
  end

  describe '#update_weight_goal' do
    it 'updates weight goal'
  end

  #=================
  # Weight
  #==================

  describe '#weight_on_date' do
    it 'gets weight on date'
  end

  describe '#weight_for_period' do
    it 'gets weight for period'
  end

  describe '#weight_for_range' do
    it 'gets weight for range'
  end

  describe '#log_weight' do
    it 'logs weight'
  end

  describe 'delete_logged_weight' do
    it 'deletes logged weight'
  end

end
