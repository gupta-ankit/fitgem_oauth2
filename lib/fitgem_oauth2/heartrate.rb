# frozen_string_literal: true

module FitgemOauth2
  class Client
    HR_PERIODS = %w[1d 7d 30d 1w 1m].freeze
    HR_DETAIL_LEVELS = %w[1sec 1min].freeze

    def hr_series_for_date_range(start_date, end_date)
      validate_start_date(start_date)
      validate_end_date(end_date)

      url = ['user', user_id, 'activities/heart/date', format_date(start_date), format_date(end_date)].join('/')
      get_call("#{url}.json")
    end

    def hr_series_for_period(start_date, period)
      validate_start_date(start_date)
      validate_hr_period(period)

      url = ['user', user_id, 'activities/heart/date', format_date(start_date), period].join('/')
      get_call("#{url}.json")
    end

    # retrieve intraday series for heartrate
    def intraday_heartrate_time_series(start_date: nil, end_date: nil, detail_level: nil, start_time: nil,
                                       end_time: nil)
      intraday_series_guard(
        start_date: start_date,
        detail_level: detail_level,
        start_time: start_time,
        end_time: end_time
      )

      end_date = format_date(end_date) || '1d'

      url = ['user', user_id, 'activities/heart/date', format_date(start_date), end_date, detail_level].join('/')

      url = [url, 'time', format_time(start_time), format_time(end_time)].join('/') if start_time && end_time

      get_call("#{url}.json")
    end

    private

    def validate_hr_period(period)
      return if period && HR_PERIODS.include?(period)

      raise FitgemOauth2::InvalidArgumentError, "Invalid period: #{period}. Valid periods are #{HR_PERIODS}."
    end

    def intraday_series_guard(start_date:, detail_level:, start_time:, end_time:)
      raise FitgemOauth2::InvalidArgumentError, 'Start date not provided.' unless start_date

      unless detail_level && HR_DETAIL_LEVELS.include?(detail_level)
        raise FitgemOauth2::InvalidArgumentError,
              "Please specify the defail level. Detail level should be one of #{HR_DETAIL_LEVELS}."
      end

      return unless (start_time && !end_time) || (end_time && !start_time)

      raise FitgemOauth2::InvalidArgumentError, 'Either specify both the start_time and end_time or specify neither.'
    end
  end
end
