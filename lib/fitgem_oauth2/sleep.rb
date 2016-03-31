module FitgemOauth2

  class Client

    def sleep_on_date(date)
      get_call("user/#{user_id}/sleep/date/#{format_date(date)}.json")
    end
    
  end

end
