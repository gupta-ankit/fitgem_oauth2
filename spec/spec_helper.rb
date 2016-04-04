require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
Bundler.setup

require 'fitgem_oauth2'

require 'factory_girl'
FactoryGirl.definition_file_paths = %w(spec/factories)
FactoryGirl.find_definitions

RSpec.configure do |config|
  # some (optional) config here
end

def random_sequence
  (0...8).map { (65 + rand(26)).chr }.join
end
