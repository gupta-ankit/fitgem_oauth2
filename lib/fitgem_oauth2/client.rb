require 'base64'
require 'faraday'

module FitgemOauth2
  class Client

    attr_accessor :token

    attr_accessor :user_id

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


    def activities_on_date(date)
      connection.get "1/user/#{user_id}/activities/date/#{format_date(date)}.json" do |request|
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Content-Type'] = "application/x-www-form-urlencoded"
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

    attr_accessor :connection

    def format_date(date)
      date
    end

    def get(url)

    end

    def raw_get(url)
    end

  end
end
