module FitgemOauth2
  class Client

    def format_date(date)
      valid_semantic_date = %w(today yesterday).include? date
      valid_date_string = ((date =~ /\d{4}\-\d{2}\-\d{2}/) == 0)
      if valid_date_string
        date
      elsif valid_semantic_date
        date_from_semantic(date)
      elsif Date === date || Time === date || DateTime === date
        date.strftime('%Y-%m-%d')
      else
        raise FitgemOauth2::InvalidDateArgument, "Date used must be a date/time object or a string in the format YYYY-MM-DD; supplied argument is a #{date.class}"
      end
    end

    private
    def date_from_semantic(semantic)
      if semantic === 'yesterday'
        (Date.today-1).strftime('%Y-%m-%d')
      elsif semantic == 'today'
        Date.today.strftime('%Y-%m-%d')
      end
    end
  end
end
