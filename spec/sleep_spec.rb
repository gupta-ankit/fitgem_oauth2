# frozen_string_literal: true

require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }
  let(:response) { random_sequence }

  def get_test(url, method, *args)
    expect(client).to receive(:get_call).with(url).and_return(response)
    if args.empty?
      expect(client.public_send(method)).to eql(response)
    else
      expect(client.public_send(method, args[0])).to eql(response)
    end
  end

  def get_1_2_test(url, method, *args)
    expect(client).to receive(:get_call_1_2).with(url).and_return(response)
    if args.empty?
      expect(client.public_send(method)).to eql(response)
    elsif args.size == 1
      expect(client.public_send(method, args[0])).to eql(response)
    elsif args.size == 2
      expect(client.public_send(method, args[0], args[1])).to eql(response)
    else
      raise_error 'Invalid argument count'
    end
  end

  describe '#sleep_logs' do
    it 'gets sleep on date' do
      get_1_2_test("user/#{user_id}/sleep/date/#{client.format_date(Date.today)}.json", 'sleep_logs', Date.today)
    end
  end

  describe '#sleep_logs_by_date_range' do
    it 'gets sleep for date range' do
      get_1_2_test("user/#{user_id}/sleep/date/#{client.format_date(Date.today.prev_day)}/#{client.format_date(Date.today)}.json", 'sleep_logs_by_date_range', Date.today.prev_day, Date.today)
    end
  end

  describe '#sleep_goal' do
    it 'gets sleep goal' do
      get_test("user/#{user_id}/sleep/goal.json", 'sleep_goal')
    end
  end

  describe '#update_sleep_goal' do
    it 'updates sleep goal' do
      params = random_sequence
      url = "user/#{user_id}/sleep/goal.json"
      expect(client).to receive(:post_call).with(url, params).and_return(response)
      expect(client.update_sleep_goal(params)).to eql(response)
    end
  end

  describe '#sleep_time_series' do
    # TODO: the tests in this block will be removed and made clean when
    # replacing sleep_time_series with cleanear methods
    before(:each) do
      @resp = random_sequence
      @yesterday = Date.today - 1
      @today = Date.today
      @valid_resource = 'startTime'
      @invalid_resource = 'dreamTime'
      @valid_period = '1d'
      @invalid_period = 'biweekly'
    end

    it 'gets sleep time series for a period' do
      url = "user/#{user_id}/sleep/#{@valid_resource}/date/#{client.format_date(@yesterday)}/#{@valid_period}.json"
      opts = {resource: 'startTime', start_date: @yesterday, period: @valid_period}
      get_test(url, 'sleep_time_series', opts)
    end

    it 'gets sleep time series for a range' do
      url = "user/#{user_id}/sleep/#{@valid_resource}/date/#{client.format_date(@yesterday)}/#{client.format_date(@today)}.json"
      opts = {resource: 'startTime', start_date: @yesterday, end_date: @today}
      get_test(url, 'sleep_time_series', opts)
    end

    it 'raises error if both end_date and period are specified' do
      opts = {resource: 'startTime', start_date: @yesterday, end_date: @today, period: @valid_period}
      expect { client.sleep_time_series(opts) }
        .to raise_error(FitgemOauth2::InvalidArgumentError, 'Both end_date and period specified. Specify only one.')
    end

    it 'raises error if start_date is not given' do
      opts = {resource: 'startTime', end_date: @today, period: @valid_period}
      expect { client.sleep_time_series(opts) }
        .to raise_error(FitgemOauth2::InvalidArgumentError, 'Start date not provided.')
    end

    it 'raises error if period is invalid' do
      opts = {resource: 'startTime', start_date: @yesterday, period: @invalid_period}
      expect { client.sleep_time_series(opts) }
        .to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid period: #{opts[:period]}. Valid periods are #{FitgemOauth2::Client::SLEEP_PERIODS}.")
    end

    it 'raises error if resource is invalid' do
      opts = {start_date: @yesterday, period: @valid_period}
      expect { client.sleep_time_series(opts) }
        .to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid resource: #{opts[:resource]}. Valid resources are #{FitgemOauth2::Client::SLEEP_RESOURCES}.")
    end
  end

  describe '#sleep_logs_list' do
    it 'returns data on valid params asc' do
      url = "user/#{user_id}/sleep/list.json?afterDate=#{client.format_date(Date.today)}&offset=0&sort=asc&limit=10"
      expect(client).to receive(:get_call_1_2).with(url).and_return(response)
      expect(client.sleep_logs_list(Date.today, 'asc', 10)).to eq(response)
    end

    it 'returns data on valid params desc' do
      url = "user/#{user_id}/sleep/list.json?beforeDate=#{client.format_date(Date.today)}&offset=0&sort=desc&limit=10"
      expect(client).to receive(:get_call_1_2).with(url).and_return(response)
      expect(client.sleep_logs_list(Date.today, 'desc', 10)).to eq(response)
    end

    it 'raises error on missing limit' do
      expect { client.sleep_logs_list(Date.today, 'xyz', nil) }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end

    it 'raises error on missing date' do
      expect { client.sleep_logs_list(nil, 'xyz', 10) }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end

    it 'raises error on invalid sort' do
      expect { client.sleep_logs_list(Date.today, 'xyz', 10) }.to raise_error(FitgemOauth2::InvalidArgumentError)
    end
  end

  describe '#log_sleep' do
    it 'logs sleep' do
      params = random_sequence
      url = "user/#{user_id}/sleep.json"
      response = random_sequence
      expect(client).to receive(:post_call_1_2).with(url, params).and_return(response)
      expect(client.log_sleep(params)).to eql(response)
    end
  end

  describe '#delete_logged_sleep' do
    it 'deletes sleep log' do
      sleep_log_id = random_sequence
      url = "user/#{user_id}/sleep/#{sleep_log_id}.json"
      response = random_sequence
      expect(client).to receive(:delete_call).with(url).and_return(response)
      expect(client.delete_logged_sleep(sleep_log_id)).to eql(response)
    end
  end
end
