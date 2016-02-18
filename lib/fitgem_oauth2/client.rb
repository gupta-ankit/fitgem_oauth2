require 'fitgem_oauth2/activity.rb'
require 'fitgem_oauth2/sleep.rb'
require 'fitgem_oauth2/steps.rb'

require 'fitgem_oauth2/utils.rb'

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
        puts "TODO. Raise an exception due to missing fitbit user id"
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


    def refresh_access_token(refresh_token)
      response = connection.post('/oauth2/token') do |request|
        encoded = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
        request.headers['Authorization'] = "Basic #{encoded}"
        request.headers['Content-Type'] = "application/x-www-form-urlencoded"
        request.params['grant_type'] = "refresh_token"
        request.params['refresh_token'] = refresh_token
      end
      response.body
    end

    private
    attr_reader :connection

  end
end
