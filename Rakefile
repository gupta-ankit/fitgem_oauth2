require 'rake/testtask'

task :console do
  exec "irb -r fitgem_oauth2 -I ./lib"
end

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
