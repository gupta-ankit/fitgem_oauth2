module FitgemOauth2
  class Client
    # @return [code, data]
    def add_subscription(collection_path, subscription_id, subscriber_id = nil)
      headers = {}
      if subscriber_id
        headers = { 'X-Fitbit-Subscriber-Id' => subscriber_id }
      end
      post_call("1/user/-/#{collection_path}/apiSubscriptions/#{subscription_id}.json", headers)
    end

    # @return [code, data]
    def delete_subscription(collection_path, subscription_id, subscriber_id = nil)
      headers = {}
      if subscriber_id
        headers = { 'X-Fitbit-Subscriber-Id' => subscriber_id }
      end
      post_call("1/user/-/#{collection_path}/apiSubscriptions/#{subscription_id}.json", headers)
    end

    # @return data
    def list_subscriptions(collection_path = nil)
      if collection_path
        get_call("1/user/-/#{collection_path}/apiSubscriptions.json")
      else
        get_call("1/user/-/apiSubscriptions.json")
      end
    end
  end
end
