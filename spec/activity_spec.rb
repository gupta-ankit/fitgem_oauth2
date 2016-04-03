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
      url = "user/#{user_id}/activities/date/#{client.format_date(Date.today)}.json"
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
      expect { client.activities_in_period(resource, Date.today, period) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "period should be one of #{FitgemOauth2::Client::ALLOWED_ACTIVITY_PERIODS}")
    end
  end

  describe '#activities_in_range' do
    it 'gets all activities in range' do
      resource = 'calories'
      url = "user/#{user_id}/#{resource}/date/#{client.format_date(Date.today - 1)}/#{client.format_date(Date.today)}.json"
      expect(client).to receive(:get_call).with(url).and_return(activities)
      expect(client.activities_in_range(resource, Date.today - 1, Date.today)).to eql(activities)
    end

    it 'raises exception if resource path is not valid' do
      resource = 'cals'
      expect { client.activities_in_range(resource, Date.today-1, Date.today) }.
          to raise_error(FitgemOauth2::InvalidArgumentError)
    end
  end

  # ==============================================
  #      TEST : Activity Logging Methods
  # ==============================================
  describe '#get_activity_list' do
    it 'gets activity list' do
      activity_list = {activity_list: 'testing'}
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/list.json").and_return(activity_list)
      expect(client.get_activity_list).to eql(activity_list)
    end
  end

  describe '#get_activity_tcx' do
    it 'gets activity tcx' do
      activity_list = {activity_list: 'testing'}
      id = 1
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/#{id}.tcx").and_return(activity_list)
      expect(client.get_activity_tcx(id)).to eql(activity_list)
    end
  end

  describe '#log_activity' do
    it 'logs activity' do
      ret_activity = '{}'
      url = "user/#{user_id}/activities.json"
      params = '{key : value}'
      expect(client).to receive(:post_call).with(url, params).and_return(ret_activity)
      expect(client.log_activity(params)).to eql(ret_activity)
    end
  end

  describe '#delete_logged_activity' do
    it 'should delete logged activity' do
      ret = '{}'
      id = 1
      url = "user/#{user_id}/activities/#{id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(ret)
      expect(client.delete_logged_activity(id)).to eql(ret)
    end
  end

  describe '#favorite_activities' do
    it 'gets favorite activity' do
      fav_activities = {}
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/favorite.json").and_return(fav_activities)
      expect(client.favorite_activities).to eql(fav_activities)
    end
  end

  describe '#add_favorite_activity' do
    it 'adds favorite activity' do
      ret = random_sequence
      activity_id = random_sequence
      expect(client).to receive(:post_call).
          with("user/#{user_id}/activities/log/favorite/#{activity_id}.json").and_return(ret)
      expect(client.add_favorite_activity(activity_id)).to eql(ret)
    end
  end

  describe '#remove_favorite_activity' do
    it 'removes favorite activity' do
      ret = random_sequence
      activity_id = random_sequence
      expect(client).to receive(:delete_call).
          with("user/#{user_id}/activities/log/favorite/#{activity_id}.json").and_return(ret)
      expect(client.remove_favorite_activity(activity_id)).to eql(ret)
    end
  end

  # ==============================================
  #      TEST : Activity Goals
  # ==============================================

  describe '#get_activity_goals' do
    it 'gets activity goals' do
      goals = random_sequence
      period = 'daily'
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/goals/#{period}.json").and_return(goals)
      expect(client.goals(period)).to eql(goals)
    end

    it 'raises exception if period is not valid' do
      expect { client.goals('yearly') }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'")
    end
  end

  describe '#update_activity_goals' do
    it 'updates activity goals' do
      response = random_sequence
      params = random_sequence
      period = 'weekly'
      expect(client).to receive(:post_call).with("user/#{user_id}/activities/goals/#{period}.json", params).and_return(response)
      expect(client.update_activity_goals(period, params)).to eql(response)
    end

    it 'raises expection is period is not valid' do
      params = random_sequence
      expect { client.update_activity_goals('yearly', params) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'")
    end
  end

  describe '#lifetime_stats' do
    it 'returns lifetime stats' do
      life_stats = random_sequence
      expect(client).to receive(:get_call).with("user/#{user_id}/activities.json").and_return(life_stats)
      expect(client.lifetime_stats).to eql(life_stats)
    end
  end

  def random_sequence
    (0...8).map { (65 + rand(26)).chr }.join
  end

end
