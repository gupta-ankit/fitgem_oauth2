require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Default: run specs.'

RSpec::Core::RakeTask.new(:spec)
task :test => :spec

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |tsk|
    tsk.fail_on_error = false #do not fail the build if rubocop report
  end
rescue LoadError
  task :rubocop do
    $stderr.puts 'RuboCop is disabled'
  end
end

task :default => [:spec, :rubocop]