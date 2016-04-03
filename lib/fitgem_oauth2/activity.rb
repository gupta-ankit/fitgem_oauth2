module FitgemOauth2
  class Client

    # ======================================
    #      Activities Retrieval Methods
    # ======================================

    ALLOWED_ACTIVITY_PATHS = %w(calories caloriesBMR steps distance floors elevation minutesSedentary minutesLightlyActive minutesFairlyActive minutesVeryActive activityCaloriestracker/calories tracker/steps tracker/distance tracker/floors tracker/elevation tracker/minutesSedentary tracker/minutesLightlyActive tracker/minutesFairlyActive tracker/minutesVeryActive tracker/activityCalories)

    ALLOWED_ACTIVITY_PERIODS = %w(1d 7d 30d 1w 1m 3m 6m 1y max)

    def activities_on_date(date)
      get_call("user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    def activities_in_period(resource_path, date, period)
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

    # <b>DEPRECATED</b> Please use <b>activities_on_date</b> instead
    def calories_on_date(date)
      get_call("user/#{user_id}/activities/calories/date/#{format_date(date)}/1d.json")
    end

    # ======================================
    #      Activity Logging Methods
    # ======================================

    def get_activity_list
      get_call("user/#{@user_id}/activities/list.json")
    end

    def get_activity_tcx(id)
      get_call("user/#{@user_id}/activities/#{id}.tcx")
    end

    def log_activity(opts)
      post_call("user/#{@user_id}/activities.json", opts)
    end

    def add_favorite_activity(activity_id)
      post_call("user/#{@user_id}/activities/log/favorite/#{activity_id}.json")
    end

    def delete_logged_activity(id)
      delete_call("user/#{@user_id}/activities/#{id}.json")
    end


    # ======================================
    #      Intraday Series
    # ======================================

    def intraday_time_series(resource: nil, date: nil, detail_level: nil,
                             start_time: nil, end_time: nil)

      unless %i[calories steps distance floors elevation].include?(resource)
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify resource to fetch intraday time series data for.'\
              ' One of (:calories, :steps, :distance, :floors, or :elevation) is required.'
      end
      unless date
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify the date to fetch intraday time series data for.'
      end
      unless %w(1min 15min).include?(detail_level)
        raise FitgemOauth2::InvalidArgumentError,
              'Must specify the data resolution to fetch intraday time series data for.'\
              ' One of (\"1d\" or \"15min\") is required.'
      end
      resource_path = [
          'user', @user_id,
          'activities', resource,
          'date', format_date(date),
          '1d', detail_level
      ].join('/')
      if start_time || end_time
        resource_path =
            [resource_path, 'time', format_time(start_time), format_time(end_time)].join('/')
      end
      get_call("#{resource_path}.json")
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
      get_call("user/#{@user_id}/activities/frequent.json")
    end

    def recent_activities
      get_call("user/#{@user_id}/activities/recent.json")
    end

    def favorite_activities
      get_call("user/#{@user_id}/activities/favorite.json")
    end

    # ======================================
    #      Activity Goals
    # ======================================

    def goals(period)
      unless period && [:daily, :weekly].include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'"
      end
    end

    def lifetime_stats
      get_call("user/#{@user_id}/activities.json")
    end

    # ======================================
    #      Private Methods
    # ======================================

    private
    def get_activities(resource_path, first, second)
      get_call("user/#{user_id}/#{resource_path}/date/#{first}/#{second}.json")
    end

    def activity_resource_path?(resource_path)
      resource_path && ALLOWED_ACTIVITY_PATHS.include?(resource_path)
    end

    def activity_period?(period)
      period && ALLOWED_ACTIVITY_PERIODS.include?(period)
    end
  end
end
