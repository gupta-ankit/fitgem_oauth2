# frozen_string_literal: true

require 'webmock/rspec'
WebMock.enable!

require 'simplecov'
require 'simplecov-console'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::Console, SimpleCov::Formatter::LcovFormatter]
)
SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'fitgem_oauth2'

require 'factory_bot'
FactoryBot.definition_file_paths = %w[spec/factories]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include WebMock::API
end

def random_sequence
  (0...8).map { rand(65..90).chr }.join
end
