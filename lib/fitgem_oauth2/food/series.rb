# frozen_string_literal: true

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
  end
end
