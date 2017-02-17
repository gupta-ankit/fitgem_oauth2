module FitgemOauth2

  class Client

    SLEEP_RESOURCES = %w(startTime  timeInBed  minutesAsleep  awakeningsCount  minutesAwake  minutesToFallAsleep  minutesAfterWakeup  efficiency)
    SLEEP_PERIODS = %w(1d 7d 30d 1w 1m 3m 6m 1y max)

    # retrieve sleep logs for a date
    # @param date date for which sleep logs needs to be accessed
    def sleep_logs(date)
      get_call("user/#{user_id}/sleep/date/#{format_date(date)}.json")
    end

    # retrieve sleep goal for the user
    def sleep_goal
      get_call("user/#{user_id}/sleep/goal.json")
    end

    # update sleep goal
    # @param params POST parameters for updating sleep goal
    def update_sleep_goal(params)
      post_call("user/#{user_id}/sleep/goal.json", params)
    end

    # retrieve time series data for sleep
    # @param resource sleep resource to be requested
    # @param start_date starting date for sleep time series
    # @param end_date ending date for sleep time series
    # @param period period for sleep time series
    def sleep_time_series(resource: nil, start_date: nil, end_date: nil, period: nil)
      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'Start date not provided.'
      end

      unless resource && SLEEP_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "Invalid resource: #{resource}. Valid resources are #{SLEEP_RESOURCES}."
      end

      if period && end_date
        raise FitgemOauth2::InvalidArgumentError, 'Both end_date and period specified. Specify only one.'
      end

      if period && !SLEEP_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Valid periods are #{SLEEP_PERIODS}."
      end

      second = period || format_date(end_date)

      url = ['user', user_id, 'sleep', resource, 'date', format_date(start_date), second].join('/')

      get_call(url + '.json')
    end

    # log sleep
    # @param params POST params for creating sleep log
    def log_sleep(params)
      post_call("user/#{user_id}/sleep.json", params)
    end

    # deleted sleep log
    # @param log_id ID of the sleep log that needs to be removed.
    def delete_logged_sleep(log_id)
      delete_call("user/#{user_id}/sleep/#{log_id}.json")
    end
    
  end

end
