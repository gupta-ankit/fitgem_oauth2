module FitgemOauth2
  class Client

    SUBSCRIBABLE_TYPES = [:sleep, :body, :activities, :foods, :all]

    def subscriptions(opts)
      get_call(subscription_url(opts))
    end

    def create_subscription(opts)
      post_call(subscription_url(opts))
    end

    def remove_subscription(opts)
      delete_call(subscription_url(opts))
    end

    protected

    def subscription_url(opts)
      type = opts[ :type ] || :all
      subscription_id = opts[:subscription_id]

      url = [ '1', 'user', user_id ]
      url << type unless type == :all
      url << 'apiSubscriptions'
      url << subscription_id if subscription_id

      return url.join('/') + '.json'
    end
  end
end