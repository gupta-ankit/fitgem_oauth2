module FitgemOauth2
  class Client

    FOOD_RESOURCES = %w( foods/log/caloriesIn foods/log/water )
    FOOD_PERIODS = %w( 1d 7d 30d 1w 1m 3m 6m 1y max )

    def food_goal
      get_call("user/#{@user_id}/foods/log/goal.json")
    end

    def foods_on_date(date)
      get_call("user/#{@user_id}/foods/log/date/#{format_date(date)}.json")
    end

    def water_on_date(date)
      get_call("user/#{@user_id}/foods/log/water/date/#{format_date(date)}.json")
    end

    def water_goal
      get_call("user/#{@user_id}/foods/log/water/goal.json")
    end

    def food_in_period(resource, date, period)
      unless resource && FOOD_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "resource should be one of #{FOOD_RESOURCES}"
      end

      unless period && FOOD_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "period should be one of #{FOOD_PERIODS}"
      end

      get_call("user/[user-id]/#{resource}/date/#{format_date(date)}/#{period}.json")

    end

    def food_in_range(resource, start_date, end_date)
      unless resource && FOOD_RESOURCES.include?(resource)
        raise FitgemOauth2::InvalidArgumentError, "resource should be one of #{FOOD_RESOURCES}"
      end

      get_call("user/[user-id]/#{resource}/date/#{format_date(start_date)}/#{format_date(end_date)}.json")

    end

    def food(id)
      get_call("foods/#{id}.json")
    end

    def food_units
      get_call("foods/units.json")
    end

    def food_search
      get_call("foods/search.json")
    end
  end
end
