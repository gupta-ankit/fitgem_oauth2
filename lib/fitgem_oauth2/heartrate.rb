module FitgemOauth2
  class Client

    HR_PERIODS = %w(1d 7d 30d 1w 1m)
    HR_DETAIL_LEVELS = %w(1sec 1min)

    # retrieve heartrate time series
    def heartrate_time_series(start_date: nil, end_date: nil, period: nil)
      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'Start date not provided.'
      end

      if end_date && period
        raise FitgemOauth2::InvalidArgumentError, 'Both end_date and period specified. Specify only one.'
      end

      if !end_date && !period
        raise FitgemOauth2::InvalidArgumentError, 'Neither end_date nor period specified. Specify at least one.'
      end

      if period && !HR_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Valid periods are #{HR_PERIODS}."
      end

      second = period || format_date(end_date)

      url = ['user', user_id, 'activities/heart/date', format_date(start_date), second].join('/')

      get_call(url + '.json')
    end

    # retrieve intraday series for heartrate
    def intraday_heartrate_time_series(start_date: nil, end_date: nil, detail_level: nil, start_time: nil, end_time: nil)
      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'Start date not provided.'
      end

      unless detail_level && HR_DETAIL_LEVELS.include?(detail_level)
        raise FitgemOauth2::InvalidArgumentError, "Please specify the defail level. Detail level should be one of #{HR_DETAIL_LEVELS}."
      end

      end_date = format_date(end_date) || '1d'

      url = ['user', user_id, 'activities/heart/date', format_date(start_date), end_date, detail_level].join('/')

      if (start_time && !end_time) || (end_time && !start_time)
        raise FitgemOauth2::InvalidArgumentError, 'Either specify both the start_time and end_time or specify neither.'
      end

      if start_time && end_time
        url = [url, 'time', format_time(start_time), format_time(end_time)].join('/')
      end

      get_call(url + '.json')
    end
  end
end
