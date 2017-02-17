module FitgemOauth2
  class Client

    FOOD_SERIES_RESOURCES = %w( caloriesIn water )
    FOOD_SERIES_PERIODS = %w( 1d 7d 30d 1w 1m 3m 6m 1y max )


    # ==================================
    #   Food or Water Series
    # ==================================


    def food_series(resource: nil, start_date: nil, end_date: nil, period: nil)

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

    # ==================================
    #   Collection data
    # ==================================

    def food_goals
      get_call("user/#{user_id}/foods/log/goal.json")
    end

    def food_logs(date)
      get_call("user/#{user_id}/foods/log/date/#{format_date(date)}.json")
    end

    def water_logs(date)
      get_call("user/#{user_id}/foods/log/water/date/#{format_date(date)}.json")
    end

    def water_goal
      get_call("user/#{user_id}/foods/log/water/goal.json")
    end

    def log_food(params)
      post_call("user/#{user_id}/foods/log.json", params)
    end

    def update_food_log(food_log_id, params)
      post_call("user/#{user_id}/foods/log/#{food_log_id}.json", params)
    end

    def log_water(params)
      post_call("user/#{user_id}/foods/log/water.json", params)
    end

    def update_food_goal(params)
      post_call("user/#{user_id}/foods/log/goal.json", params)
    end

    def update_water_goal(params)
      post_call("user/#{user_id}/foods/log/water/goal.json", params)
    end

    def delete_food_log(food_log_id)
      delete_call("user/#{user_id}/foods/log/#{food_log_id}.json")
    end

    def update_water_log(water_log_id, params)
      post_call("user/#{user_id}/foods/log/water/#{water_log_id}.json", params)
    end

    def delete_water_log(water_log_id)
      delete_call("user/#{user_id}/foods/log/water/#{water_log_id}.json")
    end

    # ==================================
    #   Collection Metadata
    # ==================================

    def add_favorite_food(food_id)
      post_call("user/#{user_id}/foods/log/favorite/#{food_id}.json")
    end

    def delete_favorite_food(food_id)
      delete_call("user/#{user_id}/foods/log/favorite/#{food_id}.json")
    end

    def recent_foods
      get_call("user/#{user_id}/foods/recent.json")
    end

    def favorite_foods
      get_call("user/#{user_id}/foods/log/favorite.json")
    end

    def frequent_foods
      get_call("user/#{user_id}/foods/log/frequent.json")
    end

    def meals
      get_call("user/#{user_id}/meals.json")
    end

    def create_meal(params)
      post_call("user/#{user_id}/meals.json", params)
    end

    def meal(meal_id)
      get_call("user/#{user_id}/meals/#{meal_id}.json")
    end

    def update_meal(meal_id, params)
      post_call("user/#{user_id}/meals/#{meal_id}.json", params)
    end

    def delete_meal(meal_id)
      delete_call("user/#{user_id}/meals/#{meal_id}.json")
    end

    def create_food(params)
      post_call("user/#{user_id}/foods.json", params)
    end

    def delete_food(food_id)
      delete_call("user/#{user_id}/foods/#{food_id}.json")
    end

    def food(id)
      get_call("foods/#{id}.json")
    end

    def food_units
      get_call('foods/units.json')
    end

    def search_foods(params)
      post_call('foods/search.json', params)
    end
  end
end
