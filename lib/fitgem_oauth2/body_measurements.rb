module FitgemOauth2
  class Client
    fat_periods = %w("1d" "7d" "1w" "1m")
    weight_periods = %("1d" "7d" "30d" "1w" "1m")
    body_goals = %("fat" "weight")
    # ======================================
    #      Boday Fat API
    # ======================================

    def fat_on_date(date)
      get_call("/user/#{@user_id}/body/log/fat/date/#{format_date(date)}.json")
    end

    def fat_for_period(base_date, period)
      if fat_period?(period)
        get_call("user/#{@user_id}/body/log/fat/date/#{format_date(start_date)}/#{period}.json")
      else
        raise FitgemOauth2::InvalidArgumentError, "period should be one of #{fat_periods}"
      end
    end

    def fat_for_range(start_date, end_date)
      get_call("user/#{@user_id}/body/log/fat/date/#{format_date(start_date)}/#{format_date(end_date)}.json")
    end

    # ======================================
    #      Body Goals API
    # ======================================
    
    def body_goal(type)
      if type && body_goals.include?(type)
        get_call("user/#{@user_id}/body/log/#{type}/goal.json")
      else
        raise FitgemOauth2::InvalidArgumentError, "goal type should be one of #{body_goals}"
      end
    end

    # ======================================
    #      Body Weight API
    # ======================================

    def weight_on_date(date)
      get_call("user/#{@user_id}/body/log/weight/date/#{format_date(date)}.json")
    end

    def weight_for_period(base_date, period)
      if weight_period?(period)
        get_call("user/#{@user_id}/body/log/weight/date/#{format_date(start_date)}/#{period}.json")
      else
        raise FitgemOauth2::InvalidArgumentError, "period should be one of #{weight_periods}"
      end
    end

    def weight_for_range(start_date, end_date)
      get_call("user/#{@user_id}/body/log/weight/date/#{format_date(start_date)}/#{format_date(end_date)}.json")
    end


    private
    def fat_period?(period)
      return period && fat_periods.include?(period)
    end

    def weight_period?(period)
      return period && weight_periods.include?(period)
    end

  end
end
