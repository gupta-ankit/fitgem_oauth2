# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'fitgem_oauth2/version'

Gem::Specification.new do |s|
  s.name        = 'fitgem_oauth2'
  s.version     = FitgemOauth2::VERSION
  s.summary     = 'Fitbit API client library'
  s.description = 'This gem allows requesting data from Fitbit API using OAuth2'
  s.authors     = ['Ankit Gupta']
  s.email       = 'ankit.gupta2801@gmail.com'
  s.files       = %w[fitgem_oauth2.gemspec] + `git ls-files -z`.split("\x0").select {|f| f.start_with?('lib/') }
  s.homepage    = 'http://rubygems.org/gems/fitgem_oauth2'
  s.license     = 'MIT'
  s.metadata    = {'rubygems_mfa_required' => 'true'}

  s.required_ruby_version = '>= 3.2.0'

  s.add_dependency 'faraday', '~> 2.0'

  s.add_development_dependency 'factory_bot', '~> 6.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.4'
end
