module FitgemOauth2
  class Client
    def user_info()
      get_call("1/user/#{user_id}/profile.json")
    end
  end
end
