require 'fitgem_oauth2/activity.rb'
require 'fitgem_oauth2/body_measurements.rb'
require 'fitgem_oauth2/devices.rb'
require 'fitgem_oauth2/errors.rb'
require 'fitgem_oauth2/food.rb'
require 'fitgem_oauth2/friends.rb'
require 'fitgem_oauth2/heartrate.rb'
require 'fitgem_oauth2/sleep.rb'
require 'fitgem_oauth2/steps.rb'
require 'fitgem_oauth2/subscriptions.rb'
require 'fitgem_oauth2/users.rb'
require 'fitgem_oauth2/utils.rb'
require 'fitgem_oauth2/version.rb'

require 'base64'
require 'faraday'

module FitgemOauth2
  class Client

    DEFAULT_USER_ID = '-'

    attr_reader :client_id
    attr_reader :client_secret
    attr_reader :token
    attr_reader :user_id

    def initialize(opts)
      missing = [:client_id, :client_secret, :token] - opts.keys
      if missing.size > 0
        raise FitgemOauth2::InvalidArgumentError, "Missing required options: #{missing.join(',')}"
      end

      @client_id = opts[:client_id]
      @client_secret = opts[:client_secret]
      @token = opts[:token]
      @user_id = (opts[:user_id] || DEFAULT_USER_ID)

      @connection = Faraday.new("https://api.fitbit.com")
    end

    def refresh_access_token(refresh_token)
      response = connection.post('/oauth2/token') do |request|
        encoded = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
        request.headers['Authorization'] = "Basic #{encoded}"
        request.headers['Content-Type'] = "application/x-www-form-urlencoded"
        request.params['grant_type'] = "refresh_token"
        request.params['refresh_token'] = refresh_token
      end
      return JSON.parse(response.body)
    end

    def get_call(url)
      response = connection.get(url) { |request| set_headers(request) }
      return parse_response(response)
    end

    def post_call(url, params = {})
      response = connection.post(url, params) { |request| set_headers(request) }
      return parse_response(response)
    end

    def delete_call(url)
      response = connection.delete(url) { |request| set_headers(request) }
      return parse_response(response)
    end

    private
    attr_reader :connection

    def set_headers(request)
      request.headers['Authorization'] = "Bearer #{token}"
      request.headers['Content-Type'] = "application/x-www-form-urlencoded"
    end

    def parse_response(response)
      headers_to_keep = ["fitbit-rate-limit-limit","fitbit-rate-limit-remaining","fitbit-rate-limit-reset"]

      case response.status
        when 200; return JSON.parse(response.body).merge!(response.headers.slice(*headers_to_keep))
        when 400; raise FitgemOauth2::BadRequestError
        when 401; raise FitgemOauth2::UnauthorizedError
        when 403; raise FitgemOauth2::ForbiddenError
        when 404; raise FitgemOauth2::NotFoundError
        when 500..599; raise FitgemOauth2::ServerError
      end
    end

  end
end
