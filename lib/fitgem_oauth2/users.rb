module FitgemOauth2
  class Client
    def user_info()
      get_call("user/#{user_id}/profile.json")
    end
  end
end
