# frozen_string_literal: true

module FitgemOauth2
  class Client
    ACTIVITY_RESOURCES = %w[
      calories caloriesBMR steps distance floors elevation minutesSedentary
      minutesLightlyActive minutesFairlyActive minutesVeryActive
      activityCaloriestracker/calories tracker/steps tracker/distance
      tracker/floors tracker/elevation tracker/minutesSedentary
      tracker/minutesLightlyActive tracker/minutesFairlyActive
      tracker/minutesVeryActive tracker/activityCalories
    ].freeze

    ACTIVITY_PERIODS = %w[1d 7d 30d 1w 1m 3m 6m 1y max].freeze

    # retrieves daily activity summary for a date
    # @param date the date for which the summary is retrieved
    def daily_activity_summary(date)
      get_call("user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    # ==================================
    #   Activity Time Series
    # ==================================

    # retrieves activity time series, based on the arguments provided
    # @param resource the resource for which the series needs to be retrieved. one of ALLOWED_RESOURCES
    # @param start_date the start date for the series
    # @param end_date the end date for the series. If specifying end_date, do not specify period
    # @param period the period starting from start_date for which the series needs to be retrieved. If specifying period,
    #             do not use end_date
    def activity_time_series(resource: nil, start_date: nil, end_date: nil, period: nil)
      unless resource && ACTIVITY_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError,
              "Invalid resource: #{resource}. Valid resources are #{ACTIVITY_RESOURCES}."
      end

      raise FitgemOauth2::InvalidArgumentError, 'Start date must be specified.' unless start_date

      if period && end_date
        raise FitgemOauth2::InvalidArgumentError, 'Both period and end_date are specified. Please specify only one.'
      end

      if period && !ACTIVITY_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Valid periods are #{ACTIVITY_PERIODS}."
      end

      first = format_date(start_date)
      second = period || format_date(end_date)
      url = ['user', user_id, 'activities', resource, 'date', first, second].join('/')
      get_call("#{url}.json")
    end

    # retrieves intraday activity time series.
    # @param resource (required) for which the intrady series is retrieved. one of 'calories', 'steps', 'distance', 'floors', 'elevation'
    # @param start_date (required) start date for the series
    # @param end_date (optional) end date for the series, if not specified, the series is for 1 day
    # @param detail_level (required) level of detail for the series
    # @param start_time (optional)start time for the series
    # @param end_time the (optional)end time for the series. specify both start_time and end_time, if using either
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

      unless detail_level && %w[1min 15min].include?(detail_level)
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

    # logs activity using the params.
    # @param params Hash to be posted. Refer https://dev.fitbit.com/docs/activity/#activity-logging for accepted
    #     POST parameters
    def log_activity(params)
      post_call("user/#{user_id}/activities.json", params)
    end

    # deletes a logged activity
    # @param id id of the activity log to be deleted
    def delete_logged_activity(id)
      delete_call("user/#{user_id}/activities/#{id}.json")
    end

    # retrieves activity list for the user
    def activity_list(date, sort, limit)
      date_param = format_date(date)
      if sort == 'asc'
        date_param = "afterDate=#{date_param}"
      elsif sort == 'desc'
        date_param = "beforeDate=#{date_param}"
      else
        raise FitgemOauth2::InvalidArgumentError, 'sort can either be asc or desc'
      end
      get_call("user/#{user_id}/activities/list.json?offset=0&limit=#{limit}&sort=#{sort}&#{date_param}")
    end

    # retrieves activity list in the tcx format
    def activity_tcx(id)
      get_call("user/#{user_id}/activities/#{id}.tcx")
    end

    # ======================================
    #      Activity Types
    # ======================================

    # Get a tree of all valid Fitbit public activities from the activities catalog as well
    # as private custom activities the user created in the format requested. If the activity
    # has levels, also get a list of activity level details
    def activities
      get_call('activities.json')
    end

    # Returns the details of a specific activity in the Fitbit activities database in the format requested.
    # @param id id of the activity for which the details need to be retrieved
    def activity(id)
      get_call("activities/#{id}.json")
    end

    # gets frequent activities
    def frequent_activities
      get_call("user/#{user_id}/activities/frequent.json")
    end

    # gets recent activities
    def recent_activities
      get_call("user/#{user_id}/activities/recent.json")
    end

    # gets favorite activities
    def favorite_activities
      get_call("user/#{user_id}/activities/favorite.json")
    end

    # adds the activity with the given ID to user's list of favorite activities.
    # @param activity_id ID of the activity to be added to the list of favorite activities
    def add_favorite_activity(activity_id)
      post_call("user/#{user_id}/activities/log/favorite/#{activity_id}.json")
    end

    # removes the activity with given ID from list of favorite activities.
    # @param activity_id ID of the activity to be removed from favorite activity
    def remove_favorite_activity(activity_id)
      delete_call("user/#{user_id}/activities/log/favorite/#{activity_id}.json")
    end

    # ======================================
    #      Activity Goals
    # ======================================

    # retrieve activity goals for a period
    # @period the period for which the goals need to be retrieved. either 'weekly' or 'daily'
    def goals(period)
      unless period && %w[daily weekly].include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'"
      end

      get_call("user/#{user_id}/activities/goals/#{period}.json")
    end

    # update activity goals
    # @param period period for the goal ('weekly' or 'daily')
    # @param params the POST params for the request. Refer to Fitbit documentation for accepted format
    def update_activity_goals(period, params)
      unless period && %w[daily weekly].include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Goal period should either be 'daily' or 'weekly'"
      end

      post_call("user/#{user_id}/activities/goals/#{period}.json", params)
    end

    # retrieves lifetime statistics for the user
    def lifetime_stats
      get_call("user/#{user_id}/activities.json")
    end
  end
end
