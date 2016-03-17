module FitgemOauth2
  class Client

    # ======================================
    #      Activities Retrieval Methods
    # ======================================

    allowed_activity_paths = %w("calories" "caloriesBMR" "steps" "distance" "floors" "elevation" "minutesSedentary" "minutesLightlyActive" "minutesFairlyActive" "minutesVeryActive" "activityCaloriestracker/calories" "tracker/steps" "tracker/distance" "tracker/floors" "tracker/elevation" "tracker/minutesSedentary" "tracker/minutesLightlyActive" "tracker/minutesFairlyActive" "tracker/minutesVeryActive" "tracker/activityCalories")

    allowed_activity_periods = %w("1d" "7d" "30d" "1w" "1m" "3m" "6m" "1y" "max")

    def activities_on_date(date)
      get_call("1/user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    def activities_in_period(resource_path, date, period)
      if activity_resource_path?(resource_path)
        if activity_period?(period)
          get_activities(resource_path, resource_path, period)
        else
          raise FitgemOauth2::InvalidArgumentError, "period should be one of #{allowed_activity_periods}"
        end
      else
        raise FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{allowed_activity_paths}"
      end
    end

    def activities_in_range(resource_path, base_date, end_date)
      if activity_resource_path?(resource_path)
        get_activities(resource_path, format_date(base_date), format_dat(end_date))
      else
        raise FitgemOauth2::InvalidArgumentError, "resource_path should be one of #{allowed_activity_paths}"
      end
    end

    # <b>DEPRECATED</b> Please use <b>activities_on_date</b> instead
    def calories_on_date(date)
      get_call("1/user/#{user_id}/activities/calories/date/#{format_date(date)}/1d.json")
    end

    # ======================================
    #      Intraday Series
    # ======================================

    def intraday_time_series(opts)
      unless opts[:resource] && [:calories, :steps, :distance, :floors, :elevation].include?(opts[:resource])
        raise FitgemOauth2::InvalidArgumentError, 'Must specify resource to fetch intraday time series data for. One of (:calories, :steps, :distance, :floors, or :elevation) is required.'
      end

      unless opts[:date]
        raise FitgemOauth2::InvalidArgumentError, 'Must specify the date to fetch intraday time series data for.'
      end

      unless opts[:detailLevel] && %w(1min 15min).include?(opts[:detailLevel])
        raise FitgemOauth2::InvalidArgumentError, 'Must specify the data resolution to fetch intraday time series data for. One of (\"1d\" or \"15min\") is required.'
      end

      resource = opts.delete(:resource)
      date = format_date(opts.delete(:date))
      detail_level = opts.delete(:detailLevel)
      time_window_specified = opts[:startTime] || opts[:endTime]
      resource_path = "1/user/#{@user_id}/activities/"

      if time_window_specified
        start_time = format_time(opts.delete(:startTime))
        end_time = format_time(opts.delete(:endTime))
        resource_path += "#{resource}/date/#{date}/1d/#{detail_level}/time/#{start_time}/#{end_time}.json"
      else
        resource_path += "#{resource}/date/#{date}/1d/#{detail_level}.json"
      end
      get_call(resource_path)
    end

    # ======================================
    #      Activity Types
    # ======================================
    def activities
      get_call("1/activities.json")
    end

    def activity(id)
      get_call("1/activities/#{id}.json")
    end

    def frequent_activities
      get_call("1/user/#{@user_id}/activities/frequent.json")
    end

    def recent_activities
      get_call("1/user/#{@user_id}/activities/recent.json")
    end

    def favorite_activities
      get_call("1/user/#{@user_id}/activities/favorite.json")
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
      get_call("1/user/#{@user_id}/activities.json")
    end

    # ======================================
    #      Private Methods
    # ======================================

    private
    def get_activities(resource_path, first, second)
      get_call("1/user/#{user_id}/#{resource_path}/date/#{first}/#{second}.json")
    end

    def activity_resource_path?(resource_path)
      return resource_path && allowed_activity_paths.include?(resource_path)
    end

    def activity_period?(period)
      return period && allowed_activity_periods.include?(period)
    end
  end
end
