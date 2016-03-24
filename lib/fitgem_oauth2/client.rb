require 'fitgem_oauth2/activity.rb'
require 'fitgem_oauth2/body_measurements.rb'
require 'fitgem_oauth2/devices.rb'
require 'fitgem_oauth2/errors.rb'
require 'fitgem_oauth2/food.rb'
require 'fitgem_oauth2/friends.rb'
require 'fitgem_oauth2/heartrate.rb'
require 'fitgem_oauth2/sleep.rb'
require 'fitgem_oauth2/steps.rb'
require 'fitgem_oauth2/subscription.rb'
require 'fitgem_oauth2/users.rb'
require 'fitgem_oauth2/utils.rb'
require 'fitgem_oauth2/version.rb'

require 'base64'
require 'faraday'

module FitgemOauth2
  class Client

    attr_reader :token

    attr_reader :user_id

    attr_reader :client_id

    attr_reader :client_secret

    def initialize(opts)
      @client_id = opts[:client_id]
      if @client_id.nil?
        puts "TODO. Raise an exception due to missing client id"
      end

      @client_secret = opts[:client_secret]
      if @client_secret.nil?
        puts "TODO. Raise an exception due to missing client secret"
      end

      @token = opts[:token]
      if @token.nil?
        puts "TODO. Raise an exception due to missing token"
      end

      @user_id = opts[:user_id]
      if @user_id.nil?
        @user_id = "-"
      end

      @connection = Faraday.new("https://api.fitbit.com")
    end

    def get_call(url)
      response = connection.get(url)  do |request|
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Content-Type'] = "application/x-www-form-urlencoded"
      end

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

    # @param payload [Hash] or similar will be converted to json
    # @return [Array] of [response_code, response_data] where the data
    #         is parsed JSON similar to what you get back from a get
    #         call.
    def post_call(url, headers = {}, payload = nil)
      response = connection.post  do |request|
        json_request(request, url, payload, headers)
      end
      json_response(response)
    end

    def delete_call(url, headers = {}, payload = nil)
      response = connection.delete do |request|
        json_request(request, url, payload, headers)
      end
      json_response(response)
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

    private
    attr_reader :connection

    # Configure a faraday request for json interaction
    def json_request(request, url, payload, headers)
      request.url = url
      request.headers['Authorization'] = "Bearer #{token}"
      request.headers['Content-Type'] = 'application/json'
      request.headers.merge!(headers) if headers
      request.body = payload.to_json if payload
    end

    # Parse a json response, returning [code, data] tuple.
    def json_response(response)
      headers_to_keep = ["fitbit-rate-limit-limit","fitbit-rate-limit-remaining","fitbit-rate-limit-reset"]
      raise FitgetmOauth2::ServerError if response.status >= 500
      [response.status, JSON.parse(response.body).merge!(response.headers.slice(*headers_to_keep))]
    end
  end
end
