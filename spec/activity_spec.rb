require 'spec_helper'

describe FitgemOauth2::Client do

  let(:client) { FactoryGirl.build(:client) }
  let(:user_id) { client.user_id }

  let(:activities) { {} }

  describe '#activities_on_date' do
    it 'gets all activities on date' do
      expect(client).to receive(:activities_on_date).with(Date.today).and_return(activities)
      expect(client.activities_on_date(Date.today)).to eql(activities)
    end
  end

  describe '#activities_in_period' do
    it 'gets all activities in period' do
      resource = 'calories'
      period = '1d'
      expect(client).to receive(:activities_in_period).with(resource, Date.today, period).and_return(activities)
      expect(client.activities_in_period(resource, Date.today, period)).to eql(activities)
    end

    it 'rasies exception if valid resource is not specified' do
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

    # for this test to pass, the client should either not be a mock version;
    # otherwise, it will throw Authorization error and check for that
    it 'does not raise exception if all arguments are valid'
  end

end
