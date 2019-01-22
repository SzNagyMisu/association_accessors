require "bundler/setup"
require "association_accessors"
require 'dummy'

RSPEC_MAJOR_VERSION = RSpec::Core::Version::STRING.split('.').first.to_i

RSpec.configure do |config|
  if RSPEC_MAJOR_VERSION == 3
    # Enable flags like --only-failures and --next-failure
    config.example_status_persistence_file_path = ".rspec_status"

    # Disable RSpec exposing methods globally on `Module` and `main`
    config.disable_monkey_patching!
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run_excluding activerecord: proc { |versions|
    versions.none? { |version| ActiveRecord.gem_version.to_s.include? version }
  }
end
