require 'faraday'

module FitgemOauth2
  class Client

    attr_accessor :token

    attr_accessor :user_id

    def initialize(opts)
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
        request.headers['Authorization'] = "Basic #{token}"
      end
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
