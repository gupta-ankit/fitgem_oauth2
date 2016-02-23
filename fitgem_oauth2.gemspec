Gem::Specification.new do |s|
  s.name        = 'fitgem_oauth2'
  s.version     = '0.0.5'
  s.date        = '2016-01-18'
  s.summary     = "This gem allows requesting data from Fitbit API using OAuth2"
  s.description = "This gem allows requesting data from Fitbit API using OAuth2"
  s.authors     = ["Ankit Gupta"]
  s.email       = 'ankit.gupta2801@gmail.com'
  s.files       = %w(fitgem_oauth2.gemspec) + `git ls-files -z`.split("\x0").select { |f| f.start_with?("lib/") }
  s.homepage    = 'http://rubygems.org/gems/fitgem_oauth2'
  s.license     = 'MIT'

  s.add_runtime_dependency 'faraday', '~> 0.9'
end
