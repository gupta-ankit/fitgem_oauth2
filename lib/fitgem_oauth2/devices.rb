module FitgemOauth2
  class Client

    # ==================================
    #   Devices
    # ==================================
    def devices
      get_call("user/#{user_id}/devices.json")
    end

    # ==================================
    #   Alarams
    # ==================================
    def alarms(tracker_id)
      get_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json")
    end

    def add_alarm(tracker_id, params)
      post_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json", params)
    end

    def update_alarm(tracker_id, alarm_id, params)
      post_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json", params)
    end

    def remove_alarm(tracker_id, alarm_id)
      delete_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json")
    end
  end
end
