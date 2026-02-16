# frozen_string_literal: true

module FitgemOauth2
  class Client
    SUBSCRIBABLE_TYPES = %i[sleep body activities foods all].freeze

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
      type = opts[:type] || :all
      subscription_id = opts[:subscription_id]

      url = ['user', user_id]
      url << type unless type == :all
      url << 'apiSubscriptions'
      url << subscription_id if subscription_id

      "#{url.join('/')}.json"
    end
  end
end
