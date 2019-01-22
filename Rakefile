require "bundler/gem_tasks"
require "rspec/core/rake_task"

DEFAULT_RUBY_VERSIONS = [ '2.3.7', '2.4.1', '2.5.1' ].freeze

desc "Test against multiple ruby, activerecord and rspec versions - " +
  "set RUBY_VERSIONS to the version(s) to test with (default: #{DEFAULT_RUBY_VERSIONS.join(',').inspect})"
task :full_test do
  versions = ENV['RUBY_VERSIONS'] ? ENV['RUBY_VERSIONS'].split(',') : DEFAULT_RUBY_VERSIONS
  started_at = Time.now

  versions.each do |version|
    sh "./bin/test #{version}"
  end

  time_elapsed = (Time.now - started_at).to_i
  hours = time_elapsed / 3600
  minutes = time_elapsed / 60 % 60
  seconds = time_elapsed % 60
  puts "\nTest suit complete\n" +
    "  ruby versions: #{versions.join(', ')}\n" +
    "  run in #{hours}h #{minutes}m #{seconds}s\n"
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
