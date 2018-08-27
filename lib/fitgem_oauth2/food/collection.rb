module FitgemOauth2
  class Client
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
  end
end
