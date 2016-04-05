module FitgemOauth2
  class Client
    def friends
      get_call("user/#{user_id}/friends.json")
    end

    def friends_leaderboard
      get_call("user/#{user_id}/friends/leaderboard.json")
    end

    # ==================================
    #   Friend Invitations
    # ==================================

    def invite_friend(params)
      post_call("user/#{user_id}/friends/invitations.json", params)
    end

    def friend_invitations
      get_call("user/#{user_id}/friends/invitations.json")
    end

    def respond_to_invitation(from_user_id, params)
      post_call("user/#{user_id}/friends/invitations/#{from_user_id}.json", params)
    end

    # ==================================
    #   Badges
    # ==================================

    def badges
      get_call("user/#{user_id}/badges.json")
    end
  end
end
