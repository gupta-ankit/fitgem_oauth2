module FitgemOauth2
  class Client
    private
    def format_date(date)
      if date.is_a? String
        case date
          when 'today'
            return Date.today.strftime("%Y-%m-%d")
          when 'yesterday'
            return (Date.today-1).strftime("%Y-%m-%d")
          else
            unless date =~ /\d{4}\-\d{2}\-\d{2}/
              raise Fitgem::InvalidDateArgument, "Invalid date (#{date}), must be in yyyy-MM-dd format"
            end
            return date
        end
      elsif Date === date || Time === date || DateTime === date
        return date.strftime("%Y-%m-%d")
      else
        raise Fitgem::InvalidDateArgument, "Date used must be a date/time object or a string in the format YYYY-MM-DD; supplied argument is a #{date.class}"
      end
    end
  end
end
