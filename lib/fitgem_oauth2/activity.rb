module FitgemOauth2
  class Client

    # ======================================
    #      Activities Retrieval Methods
    # ======================================

    ACTIVITY_RESOURCES = %w(calories caloriesBMR steps distance floors elevation minutesSedentary minutesLightlyActive minutesFairlyActive minutesVeryActive activityCaloriestracker/calories tracker/steps tracker/distance tracker/floors tracker/elevation tracker/minutesSedentary tracker/minutesLightlyActive tracker/minutesFairlyActive tracker/minutesVeryActive tracker/activityCalories)

    ACTIVITY_PERIODS = %w(1d 7d 30d 1w 1m 3m 6m 1y max)

    def daily_activity_summary(date)
      get_call("user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    def activity_time_series(resource: nil, start_date: nil, end_date: nil, period: nil)

      unless resource && ACTIVITY_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "Invalid resource: #{resource}. Valid resources are #{ACTIVITY_RESOURCES}."
      end

      unless start_date
        raise FitgemOauth2::InvalidArgumentError, 'Start date must be specified.'
      end

      if period && end_date
        raise FitgemOauth2::InvalidArgumentError, 'Both period and end_date are specified. Please specify only one.'
      end

      if period && !ACTIVITY_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Valid periods are #{ACTIVITY_PERIODS}."
      end

      first = format_date(start_date)
      second = period || format_date(end_date)
      url = ['user', user_id, 'activities', resource, 'date', first, second].join('/')
      get_call(url + '.json')
    end

    # ======================================
    #      Intraday Series
    # ======================================

    def intraday_activity_time_series(resource: nil, start_date: nil, end_date: nil, detail_level: nil,
                                      start_time: nil, end_time: nil)

      # converting to symbol to allow developer to use either 'calories' or :calories
      resource = resource.to_sym

      unless %i[calories steps distance floors elevation].include?(resource)
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify resource to fetch intraday time series data for.'\
              ' One of (:calories, :steps, :distance, :floors, or :elevation) is required.'
      end

      unless start_date
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify the start_date to fetch intraday time series data'
      end

      end_date ||= '1d'

      unless detail_level && %w(1min 15min).include?(detail_level)
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify the data resolution to fetch intraday time series data for.'\
              ' One of (\"1d\" or \"15min\") is required.'
      end

      resource_path = [
          'user', @user_id,
          'activities', resource,
          'date', format_date(start_date),
          end_date, detail_level
      ].join('/')

      if start_time || end_time
        resource_path =
            [resource_path, 'time', format_time(start_time), format_time(end_time)].join('/')
      end
      get_call("#{resource_path}.json")
    end

    # ======================================
    #      Activity Logging Methods
    # ======================================

    def log_activity(params)
      post_call("user/#{user_id}/activities.json", params)
    end

    def delete_logged_activity(id)
      delete_call("user/#{user_id}/activities/#{id}.json")
    end

    def activity_list
      get_call("user/#{user_id}/activities/list.json")
    end

    def activity_tcx(id)
      get_call("user/#{user_id}/activities/#{id}.tcx")
    end

    def add_favorite_activity(activity_id)
      post_call("user/#{user_id}/activities/log/favorite/#{activity_id}.json")
    end

    def remove_favorite_activity(activity_id)
      delete_call("user/#{user_id}/activities/log/favorite/#{activity_id}.json")
    end

    # ======================================
    #      Activity Types
    # ======================================
    def activities
      get_call("activities.json")
    end

    def activity(id)
      get_call("activities/#{id}.json")
    end

    def frequent_activities
      get_call("user/#{user_id}/activities/frequent.json")
    end

    def recent_activities
      get_call("user/#{user_id}/activities/recent.json")
    end

    def favorite_activities
      get_call("user/#{user_id}/activities/favorite.json")
    end

    # ======================================
    #      Activity Goals
    # ======================================

    def goals(period)
      unless period && %w(daily weekly).include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'"
      end
      get_call("user/#{user_id}/activities/goals/#{period}.json")
    end

    def update_activity_goals(period, params)
      unless period && %w(daily weekly).include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'"
      end
      post_call("user/#{user_id}/activities/goals/#{period}.json", params)
    end

    def lifetime_stats
      get_call("user/#{user_id}/activities.json")
    end
  end
end
