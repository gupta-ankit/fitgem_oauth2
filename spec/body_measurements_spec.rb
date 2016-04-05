require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  describe '#body_fat_logs' do
    before(:each) do
      @valid_period = '1d'
      @today = Date.today
      @yesterday = Date.today - 1
      @response = random_sequence
    end

    it 'returns fat logs on date' do
      url = "user/#{user_id}/body/log/fat/date/#{@today}.json"
      opts = {start_date: @today}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_fat_logs(opts)).to eql(@response)
    end

    it 'return fat logs for period' do
      url = "user/#{user_id}/body/log/fat/date/#{@yesterday}/#{@today}.json"
      opts = {start_date: @yesterday, end_date: @today}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_fat_logs(opts)).to eql(@response)
    end

    it 'returns fat logs for range' do
      url = "user/#{user_id}/body/log/fat/date/#{@yesterday}/#{@valid_period}.json"
      opts = {start_date: @yesterday, period: @valid_period}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_fat_logs(opts)).to eql(@response)
    end
  end

  describe '#log_body_fat' do
    it 'logs body fat' do
      params = random_sequence
      url = "user/#{user_id}/body/log/fat.json"
      response = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.log_body_fat(params)).to eql(response)
    end
  end

  describe '#delete_logged_body_fat' do
    it 'deletes logged body fat' do
      id = random_sequence
      response = random_sequence
      url = "user/#{user_id}/body/log/fat/#{id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_logged_body_fat(id)).to eql(response)
    end
  end

  describe '#body_time_series' do
    before(:each) do
      @valid_resource = 'bmi'
      @invalid_resource = 'height'
      @valid_period = '1d'
      @invalid_period = 'weekly'
      @yesterday = Date.today - 1
      @today = Date.today
      @response = random_sequence
    end

    it 'gets body time series for period' do
      url = "user/#{user_id}/body/#{@valid_resource}/date/#{client.format_date(@today)}/#{@valid_period}.json"
      opts = {resource: @valid_resource, start_date: @today, period: @valid_period}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_time_series(opts)).to eql(@response)
    end

    it 'gets body time series for range' do
      url = "user/#{user_id}/body/#{@valid_resource}/date/#{client.format_date(@yesterday)}/#{client.format_date(@today)}.json"
      opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_time_series(opts)).to eql(@response)
    end

    it 'raises error on invalid period' do
      opts = {resource: @valid_resource, start_date: @today, period: @invalid_period}
      expect { client.body_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid Period. Body time series period must be in #{FitgemOauth2::Client::BODY_TIME_SERIES_PERIODS}")
    end

    it 'raises error if start date is not specified' do
      opts = {resource: @valid_resource}
      expect { client.body_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'resource and start_date are required parameters. Please specify both.')
    end

    it 'raises error if both end_date and period are specified' do
      opts = {resource: @valid_resource, start_date: @yesterday, end_date: @today, period: @valid_period}
      expect { client.body_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Please specify either period or end date, not both.')
    end

    it 'raises error if resource is invalid'
  end


  #=================
  # Goals
  #==================

  describe '#body_goals' do
    before(:each) do
      @response = random_sequence
      @valid_goal_type = 'fat'
      @invalid_goal_type = 'height'
    end

    it 'gets body goals' do
      url = "user/#{user_id}/body/log/#{@valid_goal_type}/goal.json"
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.body_goals(@valid_goal_type)).to eql(@response)
    end

    it 'raises exception if goal type is not valid' do
      expect { client.body_goals(@invalid_goal_type) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "invalid goal type : #{@invalid_goal_type}. must be one of #{FitgemOauth2::Client::BODY_GOALS}")
    end
  end

  describe '#update_body_fat_goal' do
    it 'updates body fat goal' do
      url = "user/#{user_id}/body/log/fat/goal.json"
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(@response)
      expect(client.update_body_fat_goal(params)).to eql(@response)
    end
  end

  describe '#update_weight_goal' do
    it 'updates weight goal' do
      url = "user/#{user_id}/body/log/weight/goal.json"
      params = random_sequence
      expect(client).to receive(:post_call).with(url, params).and_return(@response)
      expect(client.update_weight_goal(params)).to eql(@response)
    end
  end

  #=================
  # Weight
  #==================

  describe '#weight_logs' do
    before(:each) do
      @today = Date.today
      @yesterday = Date.today - 1
      @valid_period = '1d'
      @invalid_period = 'eon'
      @response = random_sequence
    end

    it 'gets weight logs on date' do
      url = "user/#{user_id}/body/log/weight/date/#{client.format_date(@today)}.json"
      opts = {start_date: @today}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.weight_logs(opts)).to eql(@response)
    end

    it 'gets weight log for period' do
      url = "user/#{user_id}/body/log/weight/date/#{@today}/#{@valid_period}.json"
      opts = {start_date: @today, period: @valid_period}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.weight_logs(opts)).to eql(@response)
    end

    it 'gets weight log for range' do
      url = "user/#{user_id}/body/log/weight/date/#{@yesterday}/#{@today}.json"
      opts = {start_date: @yesterday, end_date: @today}
      expect(client).to receive(:get_call).with(url).and_return(@response)
      expect(client.weight_logs(opts)).to eql(@response)
    end

    it 'raises error if start date is not specified' do
      opts = {end_date: @today}
      expect { client.weight_logs(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'start_date not specified.')
    end

    it 'raises error if period is invalid' do
      opts = {start_date: @yesterday, period: @invalid_period}
      expect { client.weight_logs(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "valid period not specified. please choose a period from #{FitgemOauth2::Client::WEIGHT_PERIODS}")
    end

    it 'raises error if both end_date and period are specified' do
      opts = {start_date: @yesterday, end_date: @today, period: @valid_period}
      expect { client.weight_logs(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'both end_date and period specified. please provide only one.')
    end
  end

  describe '#log_weight' do
    it 'logs weight' do
      params = random_sequence
      response = random_sequence
      url = "user/#{user_id}/body/log/weight.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.log_weight(params)).to eql(response)
    end
  end

  describe 'delete_logged_weight' do
    it 'deletes logged weight' do
      id = random_sequence
      response = random_sequence
      url = "user/#{user_id}/body/log/weight/#{id}.json"
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_logged_weight(id)).to eql(response)
    end
  end

end
