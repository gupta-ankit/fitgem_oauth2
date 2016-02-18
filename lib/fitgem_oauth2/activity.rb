module FitgemOauth2
  class Client

    def activities_on_date(date)
      get_call("1/user/#{user_id}/activities/date/#{format_date(date)}.json")
    end
    
  end
end
