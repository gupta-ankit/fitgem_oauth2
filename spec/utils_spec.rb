require 'spec_helper'

describe FitgemOauth2::Client do
  let(:client) {FactoryGirl.build(:client)}

  describe '#format_date' do
    it 'converts date object to yyyy-mm-dd' do
      expect(client.format_date(Date.today)).to eq(Date.today.strftime(('%Y-%m-%d')))
    end

    it 'converts semantic date to yyyy-mm-dd' do
      expect(client.format_date('today')).to eq(Date.today.strftime(('%Y-%m-%d')))
      expect(client.format_date('yesterday')).to eq(Date.today.prev_day.strftime(('%Y-%m-%d')))
    end

    it 'returns valid date string as it is' do
      expect(client.format_date('2018-01-01')).to eq('2018-01-01')
    end

    it 'raises error on invalid string' do
      expect{client.format_date('abcd')}.to raise_error(FitgemOauth2::InvalidDateArgument)
    end
  end

  describe 'format_time' do
    it 'returns Datetime object as string' do
      now = DateTime.now
      expect(client.format_time(now)).to eq(now.strftime('%H:%M'))
    end

    it 'raises error on invalid argument' do
      expect{client.format_time('abcd')}.to raise_error(FitgemOauth2::InvalidTimeArgument)
    end

    it 'raises error on nil argument' do
      expect{client.format_time(nil)}.to raise_error(FitgemOauth2::InvalidTimeArgument)
    end
  end
end
