module FitgemOauth2
  class Client
    def food_goal
      get_call("1/user/#{@user_id}/foods/log/goal.json")
    end

    def foods_on_date(date)
      get_call("1/user/#{@user_id}/foods/log/date/#{format_date(date)}.json")
    end

    def water_on_date(date)
      get_call("1/user/#{@user_id}/foods/log/water/date/#{format_date(date)}.json")
    end

    def water_goal
      get_call("1/user/#{@user_id}/foods/log/water/goal.json")
    end

    def food_in_period(resource, date, period)
      food_resources = ["foods/log/caloriesIn", "foods/log/water"]
      food_periods = %w("1d" "7d" "30d" "1w" "1m" "3m" "6m" "1y" "max")

      unless resource && food_resources.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "resource should be one of #{food_resources}"
      end

      unless period && food_periods.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "period should be one of #{food_periods}"
      end

      get_call("1/user/[user-id]/#{resource}/date/#{format_date(date)}/#{period}.json")

    end

    def food_in_range(resource, start_date, end_date)
      food_resources = ["foods/log/caloriesIn", "foods/log/water"]

      unless resource && food_resources.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "resource should be one of #{food_resources}"
      end

      get_call("1/user/[user-id]/#{resource}/date/#{format_date(start_date)}/#{format_date(end_date)}.json")

    end

    def food(id)
      get_call("1/foods/#{id}.json")
    end

    def food_units
      get_call("1/foods/units.json")
    end

    def food_search
      get_call("1/foods/search.json")
    end
  end
end
