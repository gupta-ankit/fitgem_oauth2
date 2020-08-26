# frozen_string_literal: true

require 'fitgem_oauth2/food/collection.rb'
require 'fitgem_oauth2/food/series.rb'
require 'fitgem_oauth2/food/metadata.rb'

module FitgemOauth2
  class Client
    FOOD_SERIES_RESOURCES = %w[caloriesIn water].freeze
    FOOD_SERIES_PERIODS = %w[1d 7d 30d 1w 1m 3m 6m 1y max].freeze

    private

    def validate_food_series_period(period)
      unless FOOD_SERIES_PERIODS.include?(period)
        raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Specify a valid period from #{FOOD_SERIES_PERIODS}"
      end
    end

    def food_series_url(user_id, start_date, end_date_or_period)
      ['user', user_id, 'foods/log/caloriesIn', 'date', start_date, end_date_or_period].join('/') + '.json'
    end

    def water_series_url(user_id, start_date, end_date_or_period)
      ['user', user_id, 'foods/log/water', 'date', start_date, end_date_or_period].join('/') + '.json'
    end
  end
end
