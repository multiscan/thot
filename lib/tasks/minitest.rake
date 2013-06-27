#
# run with: bundle exec  rake test
#
require "rake/testtask"

Rake::TestTask.new(:test => "db:test:prepare") do |t|
  t.libs << "test"
  # t.pattern = "test/**/*_test.rb"
  # for the moment tests on helpers do not work because of incompatibility
  # between minitest-5.0.5/lib/minitest.rb and
  # activesupport-3.2.9/lib/active_support/testing/setup_and_teardown.rb
  t.pattern = "test/{models,integration}/*_test.rb"
end

task :default => :test
