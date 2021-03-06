# frozen_string_literal: true

require 'webmock/rspec'
include WebMock::API
WebMock.enable!

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'fitgem_oauth2'

require 'factory_bot'
FactoryBot.definition_file_paths = %w[spec/factories]
FactoryBot.find_definitions

RSpec.configure do |config|
  # some (optional) config here
end

def random_sequence
  (0...8).map { rand(65..90).chr }.join
end
