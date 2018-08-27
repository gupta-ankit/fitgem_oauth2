module FitgemOauth2
  class Client
    def food_series_for_date_range(start_date, end_date)
      validate_start_date(start_date)
      validate_end_date(end_date)
      get_call(food_series_url(user_id, format_date(start_date), format_date(end_date)))
    end

    def food_series_for_period(start_date, period)
      validate_start_date(start_date)
      validate_food_series_period(period)
      get_call(food_series_url(user_id, format_date(start_date), period))
    end

    def water_series_for_date_range(start_date, end_date)
      validate_start_date(start_date)
      validate_end_date(end_date)
      get_call(water_series_url(user_id, format_date(start_date), format_date(end_date)))
    end

    def water_series_for_period(start_date, period)
      validate_start_date(start_date)
      validate_food_series_period(period)
      get_call(water_series_url(user_id, format_date(start_date), period))
    end

    def food_series(resource: nil, start_date: nil, end_date: nil, period: nil)
      warn '[DEPRECATED] use `food_series_for_date_range`, `food_series_for_period`, `water_series_for_date_range`, or `water_series_for_period` instead.'
      unless FOOD_SERIES_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "Invalid resource: #{resource}. Specify a valid resource from #{FOOD_SERIES_RESOURCES}"
      end

      if end_date && period
        raise FitgemOauth2::InvalidArgumentError, 'Provide only one of end_date and period.'
      end

      if !end_date && !period
        raise FitgemOauth2::InvalidArgumentError, 'Provide at least one of end_date and period.'
      end

      url = ['user', user_id, 'foods/log', resource, 'date', start_date].join('/')

      if period
        unless FOOD_SERIES_PERIODS.include?(period)
          raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Specify a valid period from #{FOOD_SERIES_PERIODS}"
        end
      end

      second = period || format_date(end_date)
      url = [url, second].join('/')

      get_call(url + '.json')
    end
  end
end
