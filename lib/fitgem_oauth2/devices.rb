module FitgemOauth2
  class Client

    # ==================================
    #   Devices
    # ==================================

    # return list of Fitbit devices linked to the account
    def devices
      get_call("user/#{user_id}/devices.json")
    end

    # ==================================
    #   Alarams
    # ==================================

    # returns list of alarams for the tracker ID
    # @param tracker_id ID for the tracker for which alarams need to be retrieved
    def alarms(tracker_id)
      get_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json")
    end

    # adds an alaram
    # @param tracker_id ID of the tracker to which the alaram needs to be added
    # @param params POST parameters for adding the alarm
    def add_alarm(tracker_id, params)
      post_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms.json", params)
    end

    # update an existing alarm
    # @param tracker_id ID of the tracker to which alaram needs to be added.
    # @param alarm_id ID of the alarm that needs to be updated
    # @param params POST parameters for updating the alarm
    def update_alarm(tracker_id, alarm_id, params)
      post_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json", params)
    end

    # removes an existing alaram
    # @param tracker_id ID of the tracker from which alaram needs to be removed
    # @params alarm_id ID of the alaram that needs to be removed
    def remove_alarm(tracker_id, alarm_id)
      delete_call("user/#{user_id}/devices/tracker/#{tracker_id}/alarms/#{alarm_id}.json")
    end
  end
end
