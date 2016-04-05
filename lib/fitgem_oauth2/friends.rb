module FitgemOauth2
  class Client
    # retrieves list of friends for the current user
    def friends
      get_call("user/#{user_id}/friends.json")
    end

    # retrieves leaderboard for the user
    def friends_leaderboard
      get_call("user/#{user_id}/friends/leaderboard.json")
    end

    # ==================================
    #   Friend Invitations
    # ==================================

    # send an invitation to a friend
    # @param params POST parameters for sending friend invite.
    def invite_friend(params)
      post_call("user/#{user_id}/friends/invitations.json", params)
    end

    # retrieve list of friend invitations
    def friend_invitations
      get_call("user/#{user_id}/friends/invitations.json")
    end

    # respond to a friend invite
    # @param from_user_id the ID of the friend
    # @param params POST parameters for responding to the invite.
    def respond_to_invitation(from_user_id, params)
      post_call("user/#{user_id}/friends/invitations/#{from_user_id}.json", params)
    end

    # ==================================
    #   Badges
    # ==================================

    # retrieve badges for the user
    def badges
      get_call("user/#{user_id}/badges.json")
    end
  end
end
