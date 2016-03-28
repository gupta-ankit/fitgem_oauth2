module FitgemOauth2
  class Client

    def subscriptions(opts)
      get_call("1/user/#{user_id}/apiSubscriptions.json")
    end

    def create_subscription(opts)
      post_call("1/user/#{user_id}/apiSubscriptions/#{opts[:subscription_id]}.json")
    end

    def remove_subscription(opts)
      delete_call("1/user/#{user_id}/apiSubscriptions/#{opts[:subscription_id]}.json")
    end
  end
end