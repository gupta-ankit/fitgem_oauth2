module FitgemOauth2
  class Client

    def activities_on_date(date)
      get_call("1/user/#{user_id}/activities/date/#{format_date(date)}.json")
    end

    def calories_on_date(date)
      get_call("1/user/#{user_id}/activities/calories/date/#{format_date(date)}/1d.json")
    end


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
  end
end
