module FitgemOauth2
  class Client
    FAT_PERIODS = %w(1d 7d 1w 1m)
    WEIGHT_PERIODS = %w(1d 7d 30d 1w 1m)
    BODY_GOALS = %w(fat weight)
    BODY_TIME_SERIES_PERIODS = %w(1d 7d 30d 1w 1m 3m 6m 1y max)

    # ======================================
    #      Boday Fat
    # ======================================

    def body_fat_logs(start_date: nil, end_date: nil, period: nil)
      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'must specify start_date'
      end
      url = ['user', user_id, 'body/log/fat/date', format_date(start_date)].join('/')
      if end_date
        url = [url, format_date(end_date)].join('/')
      end

      if period
        if FAT_PERIODS.include?(period)
          url = [url, period].join('/')
        else
          raise FitgemOauth2::InvalidArgumentError, "period must be one in #{FAT_PERIODS}"
        end
      end

      url = url + '.json'

      get_call(url)
    end

    def log_body_fat(params)
      post_call("user/#{user_id}/body/log/fat.json", params)
    end

    def delete_logged_body_fat(id)
      delete_call("user/#{user_id}/body/log/fat/#{id}.json")
    end


    # ==================================
    #   Body Time Series
    # ==================================

    def body_time_series(resource: nil, start_date: nil, end_date: nil, period: nil)
      unless resource && start_date
        raise FitgemOauth2::InvalidArgumentError, 'resource and start_date are required parameters. Please specify both.'
      end

      url = ['user', user_id, 'body', resource, 'date', format_date(start_date)].join('/')

      second = ''
      if end_date && period
        raise FitgemOauth2::InvalidArgumentError, 'Please specify either period or end date, not both.'
      end

      if period
        if BODY_TIME_SERIES_PERIODS.include?(period)
          second = period
        else
          raise FitgemOauth2::InvalidArgumentError, "Invalid Period. Body time series period must be in #{BODY_TIME_SERIES_PERIODS}"
        end
      end

      if end_date
        second = format_date(end_date)
      end

      url = [url, second].join('/')

      get_call(url + '.json')
    end


    # ======================================
    #      Body Goals
    # ======================================

    def body_goals(type)
      if type && BODY_GOALS.include?(type)
        get_call("user/#{user_id}/body/log/#{type}/goal.json")
      else
        raise FitgemOauth2::InvalidArgumentError, "invalid goal type : #{type}. must be one of #{BODY_GOALS}"
      end
    end

    def update_body_fat_goal(params)
      post_call("user/#{user_id}/body/log/fat/goal.json", params)
    end

    def update_weight_goal(params)
      post_call("user/#{user_id}/body/log/weight/goal.json", params)
    end

    # ======================================
    #      Body Weight
    # ======================================

    def weight_logs(start_date: nil, end_date: nil, period: nil)
      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'start_date not specified.'
      end

      if period && end_date
        raise FitgemOauth2::InvalidArgumentError, 'both end_date and period specified. please provide only one.'
      end

      if period
        unless WEIGHT_PERIODS.include?(period)
          raise FitgemOauth2::InvalidArgumentError, "valid period not specified. please choose a period from #{WEIGHT_PERIODS}"
        end
      end

      first = format_date(start_date)
      url = ['user', user_id, 'body/log/weight/date', first].join('/')
      if period || end_date
        second = period || format_date(end_date)
        url = [url, second].join('/')
      end

      get_call(url + '.json')
    end


    def log_weight(params)
      post_call("user/#{user_id}/body/log/weight.json", params)
    end

    def delete_logged_weight(id)
      delete_call("user/#{user_id}/body/log/weight/#{id}.json")
    end

  end
end
