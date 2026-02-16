# frozen_string_literal: true

require 'fitgem_oauth2/activity'
require 'fitgem_oauth2/body_measurements'
require 'fitgem_oauth2/devices'
require 'fitgem_oauth2/errors'
require 'fitgem_oauth2/food'
require 'fitgem_oauth2/friends'
require 'fitgem_oauth2/heartrate'
require 'fitgem_oauth2/sleep'
require 'fitgem_oauth2/subscriptions'
require 'fitgem_oauth2/users'
require 'fitgem_oauth2/utils'
require 'fitgem_oauth2/version'

require 'base64'
require 'faraday'

module FitgemOauth2
  class Client
    DEFAULT_USER_ID = '-'
    API_VERSION = '1'

    attr_reader :client_id, :client_secret, :token, :user_id, :unit_system

    def initialize(opts)
      missing = %i[client_id client_secret token] - opts.keys
      raise FitgemOauth2::InvalidArgumentError, "Missing required options: #{missing.join(',')}" unless missing.empty?

      @client_id = opts[:client_id]
      @client_secret = opts[:client_secret]
      @token = opts[:token]
      @user_id = (opts[:user_id] || DEFAULT_USER_ID)
      @unit_system = opts[:unit_system]
      @connection = Faraday.new('https://api.fitbit.com')
    end

    def refresh_access_token(refresh_token)
      response = connection.post('/oauth2/token') do |request|
        encoded = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
        request.headers['Authorization'] = "Basic #{encoded}"
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        request.params['grant_type'] = 'refresh_token'
        request.params['refresh_token'] = refresh_token
      end
      JSON.parse(response.body)
    end

    def revoke_token(token)
      response = connection.post('/oauth2/revoke') do |request|
        encoded = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
        request.headers['Authorization'] = "Basic #{encoded}"
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        request.params['token'] = token
      end
      JSON.parse(response.body)
    end

    def get_call(url)
      url = "#{API_VERSION}/#{url}"
      response = connection.get(url) {|request| set_headers(request) }
      parse_response(response)
    end

    # This method is a helper method (like get_call) for 1.2 version of the API_VERSION
    # This method is needed because Fitbit API supports both versions as of current
    # date (Nov 5, 2017)
    def get_call12(url)
      url = "1.2/#{url}"
      response = connection.get(url) {|request| set_headers(request) }
      parse_response(response)
    end

    def post_call(url, params={})
      url = "#{API_VERSION}/#{url}"
      response = connection.post(url, params) {|request| set_headers(request) }
      parse_response(response)
    end

    def post_call12(url, params={})
      url = "1.2/#{url}"
      response = connection.post(url, params) {|request| set_headers(request) }
      parse_response(response)
    end

    def delete_call(url)
      url = "#{API_VERSION}/#{url}"
      response = connection.delete(url) {|request| set_headers(request) }
      parse_response(response)
    end

    private

    attr_reader :connection

    # rubocop:disable Naming/AccessorMethodName
    def set_headers(request)
      request.headers['Authorization'] = "Bearer #{token}"
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      request.headers['Accept-Language'] = unit_system unless unit_system.nil?
    end
    # rubocop:enable Naming/AccessorMethodName

    def parse_response(response)
      headers_to_keep = %w[fitbit-rate-limit-limit fitbit-rate-limit-remaining fitbit-rate-limit-reset]

      error_handler = {
        200 => lambda {
          body = JSON.parse(response.body)
          body = {body: body} if body.is_a?(Array)
          headers = response.headers.to_hash.keep_if do |k, _v|
            headers_to_keep.include? k
          end
          body.merge!(headers)
        },
        201 => -> {},
        204 => -> {},
        400 => -> { raise FitgemOauth2::BadRequestError },
        401 => -> { raise FitgemOauth2::UnauthorizedError },
        403 => -> { raise FitgemOauth2::ForbiddenError },
        404 => -> { raise FitgemOauth2::NotFoundError },
        429 => -> { raise FitgemOauth2::ApiLimitError },
        500..599 => -> { raise FitgemOauth2::ServerError }
      }

      fn = error_handler.find {|k, _| k == response.status }
      raise StandardError, "Unexpected response status #{response.status}" if fn.nil?

      fn.last.call
    end
  end
end
