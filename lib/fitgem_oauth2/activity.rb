module FitgemOauth2
  class Client

    # ======================================
    #      Activities Retrieval Methods
    # ======================================

    ALLOWED_ACTIVITY_PATHS = %w(calories caloriesBMR steps distance floors elevation minutesSedentary minutesLightlyActive minutesFairlyActive minutesVeryActive activityCaloriestracker/calories tracker/steps tracker/distance tracker/floors tracker/elevation tracker/minutesSedentary tracker/minutesLightlyActive tracker/minutesFairlyActive tracker/minutesVeryActive tracker/activityCalories)

    ALLOWED_ACTIVITY_PERIODS = %w(1d 7d 30d 1w 1m 3m 6m 1y max)

    def daily_activity_summary(date)
      get_call("user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    def activity_time_series(resource_path, start_date, end_date_or_period)
      unless activity_resource_path?(resource_path)
        raise FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{ALLOWED_ACTIVITY_PATHS}"
      end
      if activity_period?(end_date_or_period)
        get_activities(resource_path, format_date(start_date), end_date_or_period)
      else
        begin
          second = format_date(end_date_or_period)
        rescue FitgemOauth2::InvalidDateArgument
          raise FitgemOauth2::InvalidArgumentError,
                "#{end_date_or_period} is neither a valid date nor a valid period. If you want to specify period, please use on of #{ALLOWED_ACTIVITY_PERIODS}"
        end
        get_activities(resource_path, format_date(start_date), second)
      end
    end

    # <b>DEPRECATED:</b> Please use <tt>activity_time_series</tt> instead.
    def activities_in_period(resource_path, date, period)
      warn '[DEPRECATION] `activities_in_period` is deprecated.  Please use `activity_time_series` instead.'
      if activity_resource_path?(resource_path)
        if activity_period?(period)
          get_activities(resource_path, format_date(date), period)
        else
          raise FitgemOauth2::InvalidArgumentError, "period should be one of #{ALLOWED_ACTIVITY_PERIODS}"
        end
      else
        raise FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{ALLOWED_ACTIVITY_PATHS}"
      end
    end

    def activities_in_range(resource_path, base_date, end_date)
      if activity_resource_path?(resource_path)
        get_activities(resource_path, format_date(base_date), format_date(end_date))
      else
        raise FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{ALLOWED_ACTIVITY_PATHS}"
      end
    end

    # ======================================
    #      Intraday Series
    # ======================================

    def intraday_time_series(resource: nil, start_date: nil, end_date: nil, detail_level: nil,
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

    def get_activity_list
      get_call("user/#{user_id}/activities/list.json")
    end

    def get_activity_tcx(id)
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

    # ======================================
    #      Private Methods
    # ======================================

    private
    def get_activities(resource_path, first, second)
      get_call("user/#{user_id}/activities/#{resource_path}/date/#{first}/#{second}.json")
    end

    def activity_resource_path?(resource_path)
      resource_path && ALLOWED_ACTIVITY_PATHS.include?(resource_path)
    end

    def activity_period?(period)
      period && ALLOWED_ACTIVITY_PERIODS.include?(period)
    end
  end
end
