# 2.2.0
* updated faraday gem to fix json vulerability in the faraday gem

# 2.0.1
* New feature - Client now throws an exception which the caller can check to see the case when the Fitbit API returns a 429


# 2.0.0 (DO NOT USE)
* This is a dirty version that did not handle the api rate limit error and had failing build (the release was made in an error and has been yanked from rubygems.org)
* added FitgemOauth2::ApiLimitError to be raised when the client hits the Fitbit API limit
