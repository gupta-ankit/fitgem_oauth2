require 'rspec'

describe FitgemOauth2::Client do
  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  describe '#heartrate_time_series' do

    before(:each) do
      @resp = random_sequence
      @yesterday = Date.today - 1
      @today = Date.today
      @valid_period = '1d'
      @invalid_resource = 'movies'
      @invalid_period = 'biweekly'
    end

    it 'gets heartrate time series for a period' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@yesterday)}/#{@valid_period}.json"
      opts = {start_date: @yesterday, period: @valid_period}
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.heartrate_time_series(opts)).to eql(response)
    end

    it 'gets heartrate time series for a range' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@yesterday)}/#{client.format_date(@today)}.json"
      opts = {start_date: @yesterday, end_date: @today}
      response = random_sequence
      expect(client).to receive(:get_call).with(url).and_return(response)
      expect(client.heartrate_time_series(opts)).to eql(response)
    end

    it 'raises error if both end_date and period are specified' do
      opts = {start_date: @yesterday, end_date: @today, period: @valid_period}
      expect { client.heartrate_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Both end_date and period specified. Specify only one.')
    end

    it 'raises error if start_date is not given' do
      opts = {end_date: @today, period: @valid_period}
      expect { client.heartrate_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, 'Start date not provided.')
    end

    it 'raises error if period is invalid' do
      opts = {start_date: @yesterday, period: @invalid_period}
      expect { client.heartrate_time_series(opts) }.
          to raise_error(FitgemOauth2::InvalidArgumentError, "Invalid period: #{opts[:period]}. Valid periods are #{FitgemOauth2::Client::HR_PERIODS}.")
    end

  end

  describe '#intraday_heartrate_time_series' do
    before(:each) do
      @start_time = '12:30'
      @end_time = '12:45'
      @start_date = Date.today - 1
      @end_date = Date.today
      @valid_detail_level = '1min'
      @resp = random_sequence
    end

    it 'gets for format#1' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@start_date)}/#{client.format_date(@end_date)}/#{@valid_detail_level}.json"
      opts = {start_date: @start_date, end_date: @end_date, detail_level: @valid_detail_level}
      expect(client).to receive(:get_call).with(url).and_return(@resp)
      expect(client.intraday_heartrate_time_series(opts)).to eql(@resp)
    end

    it 'gets for format#2' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@start_date)}/#{client.format_date(@end_date)}/#{@valid_detail_level}/time/#{@start_time}/#{@end_time}.json"
      opts = {start_date: @start_date, end_date: @end_date, detail_level: @valid_detail_level, start_time: @start_time, end_time: @end_time}
      expect(client).to receive(:get_call).with(url).and_return(@resp)
      expect(client.intraday_heartrate_time_series(opts)).to eql(@resp)
    end

    it 'gets for format#3' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@start_date)}/1d/#{@valid_detail_level}.json"
      opts = {start_date: @start_date, detail_level: @valid_detail_level}
      expect(client).to receive(:get_call).with(url).and_return(@resp)
      expect(client.intraday_heartrate_time_series(opts)).to eql(@resp)
    end

    it 'gets for format#4' do
      url = "user/#{user_id}/activities/heart/date/#{client.format_date(@start_date)}/1d/#{@valid_detail_level}/time/#{@start_time}/#{@end_time}.json"
      opts = {start_date: @start_date, detail_level: @valid_detail_level, start_time: @start_time, end_time: @end_time}
      expect(client).to receive(:get_call).with(url).and_return(@resp)
      expect(client.intraday_heartrate_time_series(opts)).to eql(@resp)
    end
  end
end
