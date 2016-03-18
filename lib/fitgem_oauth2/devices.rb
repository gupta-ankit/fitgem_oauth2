module FitgemOauth2
  class Client
    def devices
      get_call("1/user/#{@user_id}/devices.json")
    end

    def alarms(tracker_id)
      get_call("1/user/#{@user_id}/devices/tracker/#{tracker_id}/alarms.json")
    end
  end
end
