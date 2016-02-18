module FitgemOauth2
  class InvalidDateArgument < ArgumentError
  end
  
  # HTTP errors
  class BadRequestError < StandardError
  end

  class UnauthorizedError < StandardError
  end

  class ForbiddenError < StandardError
  end

  class NotFoundError < StandardError
  end

  class ServerError < StandardError
  end
end
