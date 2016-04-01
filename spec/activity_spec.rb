require 'spec_helper'

describe FitgemOauth2::Client do

  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  let(:activities) { {} }


  # ==============================================
  #      TEST : Activities Retrieval Methods
  # ==============================================
  describe '#activities_on_date' do
    it 'gets all activities on date' do
      url =  "user/#{user_id}/activities/date/#{client.format_date(Date.today)}.json"
      expect(client).to receive(:get_call).with(url).and_return(activities)
      expect(client.activities_on_date(Date.today)).to eql(activities)
    end
  end

  describe '#activities_in_period' do
    it 'gets all activities in period' do
      resource = 'calories'
      period = '1d'
      url = "user/#{user_id}/#{resource}/date/#{client.format_date(Date.today)}/#{period}.json"
      expect(client).to receive(:get_call).with(url).and_return(activities)
      expect(client.activities_in_period(resource, Date.today, period)).to eql(activities)
    end

    it 'raises exception if valid resource is not specified' do
      resource = 'cals'
      period = '1d'
      expect { client.activities_in_period(resource, Date.today, period) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{FitgemOauth2::Client::ALLOWED_ACTIVITY_PATHS}")
    end

    it 'raises exception if valid period is specified' do
      resource = 'calories'
      period = '1day'
      expect {client.activities_in_period(resource, Date.today, period)}.
          to raise_error(FitgemOauth2::InvalidArgumentError, "period should be one of #{FitgemOauth2::Client::ALLOWED_ACTIVITY_PERIODS}")
    end
  end

  describe '#activities_in_range' do
    it 'gets all activities in range'
    it 'raises exception if resource path is not valid'
  end

  # ==============================================
  #      TEST : Activity Logging Methods
  # ==============================================
  describe '#get_activity_list' do
    it 'gets activity list'
  end

  describe '#get_activity_tcx' do
    'it gets activity tcx'
  end

  describe '#log_activity' do
    it 'logs activity'
  end

  describe '#delete_logged_activity' do
    it 'should delete logged activity'
  end

  describe '#get_favorite_activity' do
    it 'gets favorite activity'
  end

  describe '#add_favorite_activity' do
    it 'adds favorite activity'
  end

  describe '#remove_favorite_activity' do
    it 'removes favorite activity'
  end

  # ==============================================
  #      TEST : Activity Goals
  # ==============================================

  describe '#get_activity_goals' do
    it 'gets activity goals'
  end

  describe 'update_activity_goals' do
    it 'updates activity goals'
  end

  describe '#lifetime_stats' do
    it 'returns lifetime stats'
  end

end
