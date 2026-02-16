# frozen_string_literal: true

module FitgemOauth2
  class Client
    def format_date(date)
      return nil if date.nil?

      if date.is_a?(String) && date.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        date
      elsif date.is_a?(String) && %w[today yesterday].include?(date)
        date_from_semantic(date)
      elsif date.is_a?(Date) || date.is_a?(Time) || date.is_a?(DateTime)
        date.strftime('%Y-%m-%d')
      else
        raise FitgemOauth2::InvalidDateArgument,
              'Date used must be a date/time object or a string in the format YYYY-MM-DD; ' \
              "supplied argument is a #{date.class}"
      end
    end

    def format_time(time)
      if time.is_a?(String) && time.match?(/\A\d{2}:\d{2}\z/)
        time
      elsif time.is_a?(DateTime) || time.is_a?(Time)
        time.strftime('%H:%M')
      else
        raise FitgemOauth2::InvalidTimeArgument,
              'Time used must be a DateTime/Time object or a string in the format hh:mm; ' \
              "supplied argument is a #{time.class}"
      end
    end

    def validate_start_date(start_date)
      raise FitgemOauth2::InvalidArgumentError, 'Please specify a valid start date.' unless start_date
    end

    def validate_end_date(end_date)
      raise FitgemOauth2::InvalidArgumentError, 'Please specify a valid end date.' unless end_date
    end

    private

    def date_from_semantic(semantic)
      if semantic == 'yesterday'
        (Date.today - 1).strftime('%Y-%m-%d')
      elsif semantic == 'today'
        Date.today.strftime('%Y-%m-%d')
      end
    end
  end
end
