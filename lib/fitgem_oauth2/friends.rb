module FitgemOauth2
  class Client
    def friends
      get_call("1/user/#{@user_id}/friends.json")
    end

    def friends_leaderboard
      get_call("1/user/#{@user_id}/friends/leaderboard.json")
    end

    def friend_invitations
      get_call("1/user/#{@user_id}/friends/invitations.json")
    end

    def badges
      get_call("1/user/#{@user_id}/badges.json")
    end
  end
end
