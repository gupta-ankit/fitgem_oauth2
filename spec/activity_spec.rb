require 'spec_helper'

describe FitgemOauth2::Client do

  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  let(:activities) { {} }


  # ==============================================
  #      TEST : Activities Retrieval Methods
  # ==============================================
  describe '#daily_activity_summary' do
    it 'gets daily activity summary date' do
      url = "user/#{user_id}/activities/date/#{client.format_date(Date.today)}.json"
      expect(client).to receive(:get_call).with(url).and_return(activities)
      expect(client.daily_activity_summary(Date.today)).to eql(activities)
    end
  end

  describe '#activity_time_series' do
    before(:each) do
      @resp = random_sequence
      @valid_resource = 'calories'
      @yesterday = Date.today - 1
      @today = Date.today
      @valid_period = '1m'
      @invalid_resource = 'movies'
      @invalid_period = 'biweekly'
    end

    it 'gets activity time series for start and end date' do
      expect(client).to receive(:get_call).
          with("user/#{user_id}/activities/#{@valid_resource}/date/#{client.format_date(@yesterday)}/#{client.format_date(@today)}.json").
          and_return(@resp)
      opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today}
      expect(client.activity_time_series(opts)).to eql(@resp)
    end

    it 'gets activity time series for base date and period' do
      expect(client).to receive(:get_call).
          with("user/#{user_id}/activities/#{@valid_resource}/date/#{client.format_date(@yesterday)}/#{@valid_period}.json").
          and_return(@resp)
      opts = {resource: @valid_resource, start_date: @yesterday, period: @valid_period}
      expect(client.activity_time_series(opts)).to eql(@resp)
    end

    it 'raises exception if the resource path is invalid' do
      opts = {resource: @invalid_resource, start_date: @yesterday, end_date: @today}
      expect { client.activity_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid resource: #{opts[:resource]}. Valid resources are #{FitgemOauth2::Client::ACTIVITY_RESOURCES}.")
    end

    it 'raises exception if period is invalid' do
      opts = {resource: @valid_resource, start_date: @yesterday, period: @invalid_period}
      expect { client.activity_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError,
                         "Invalid period: #{opts[:period]}. Valid periods are #{FitgemOauth2::Client::ACTIVITY_PERIODS}.")
    end
  end


  describe '#intraday_time_series' do
    before(:each) do
      @resp = random_sequence
      @valid_resource = 'calories'
      @yesterday = client.format_date(Date.today - 1)
      @today = client.format_date(Date.today)
      @valid_period = '1m'
      @invalid_resource = 'movies'
      @invalid_period = 'biweekly'
      @valid_detail_level = '1min'
      @invalid_detail_level = '1sec'
      @start_time = '12:30'
      @end_time = '12:45'
    end

    describe 'returns intraday time series for valid url: ' do
      it 'format #1' do
        url = "user/#{user_id}/activities/#{@valid_resource}/date/#{@yesterday}/#{@today}/#{@valid_detail_level}.json"
        opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today, detail_level: @valid_detail_level}
        expect(client).to receive(:get_call).with(url).and_return(@resp)
        expect(client.intraday_activity_time_series(opts)).to eql(@resp)
      end

      it 'format #2' do
        url = "user/#{user_id}/activities/#{@valid_resource}/date/#{@yesterday}/1d/#{@valid_detail_level}.json"
        opts = {resource: @valid_resource, start_date: @yesterday, detail_level: @valid_detail_level}
        expect(client).to receive(:get_call).with(url).and_return(@resp)
        expect(client.intraday_activity_time_series(opts)).to eql(@resp)
      end

      it 'format #3' do
        url = "user/#{user_id}/activities/#{@valid_resource}/date/#{@yesterday}/#{@today}/#{@valid_detail_level}/time/#{@start_time}/#{@end_time}.json"
        opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today, detail_level: @valid_detail_level, start_time: @start_time, end_time: @end_time}
        expect(client).to receive(:get_call).with(url).and_return(@resp)
        expect(client.intraday_activity_time_series(opts)).to eql(@resp)
      end

      it 'format #4' do
        url = "user/#{user_id}/activities/#{@valid_resource}/date/#{@today}/1d/#{@valid_detail_level}/time/#{@start_time}/#{@end_time}.json"
        opts= {resource: @valid_resource, start_date: @today, detail_level: @valid_detail_level, start_time: @start_time, end_time: @end_time}
        expect(client).to receive(:get_call).with(url).and_return(@resp)
        expect(client.intraday_activity_time_series(opts)).to eql(@resp)
      end
    end


    it 'raises exception if resource is invalid' do
      opts = {resource: @invalid_resource, start_date: @yesterday, end_date: @today, detail_level: @valid_detail_level}
      expect { client.intraday_activity_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Must specify resource to fetch intraday time series data for.'\
              ' One of (:calories, :steps, :distance, :floors, or :elevation) is required.')
    end

    it 'raises exception if detail_level is invalid' do
      opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today, detail_level: @invalid_detail_level}
      expect { client.intraday_activity_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Must specify the data resolution to fetch intraday time series data for.'\
              ' One of (\"1d\" or \"15min\") is required.')
    end

    it 'raises exception if start_date is not specified' do
      opts = {resource: @valid_resource, end_date: @today, detail_level: @invalid_detail_level}
      expect { client.intraday_activity_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Must specify the start_date to fetch intraday time series data')
    end
  end

  # ==============================================
  #      TEST : Activity Logging Methods
  # ==============================================
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

  describe '#get_activity_list' do
    it 'gets activity list' do
      activity_list = {activity_list: 'testing'}
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/list.json").and_return(activity_list)
      expect(client.activity_list).to eql(activity_list)
    end
  end

  describe '#get_activity_tcx' do
    it 'gets activity tcx' do
      activity_list = {activity_list: 'testing'}
      id = 1
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/#{id}.tcx").and_return(activity_list)
      expect(client.activity_tcx(id)).to eql(activity_list)
    end
  end

  describe '#acivities' do
    it 'gets all activities' do
      response = random_sequence
      expect(client).to receive(:get_call).with('activities.json').and_return(response)
      expect(client.activities).to eql(response)
    end
  end

  describe '#activity' do
    it 'gets a particular activity' do
      id = random_sequence
      response = random_sequence
      expect(client).to receive(:get_call).with("activities/#{id}.json").and_return(response)
      expect(client.activity(id)).to eql(response)
    end
  end

  describe '#frequent_activities' do
    it 'returns frequent activities' do
      response = random_sequence
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/frequent.json").and_return(response)
      expect(client.frequent_activities).to eql(response)
    end
  end

  describe '#recent_activities' do
    it 'returns recent activities' do
      response = random_sequence
      expect(client).to receive(:get_call).with("user/#{user_id}/activities/recent.json").and_return(response)
      expect(client.recent_activities).to eql(response)
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
end
