module FitgemOauth2

  class Client

    def steps_on_date(date)
      get_call("1/user/#{user_id}/activities/steps/date/#{format_date(date)}/1d.json")
    end

  end

end
