
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "association_accessors/version"

Gem::Specification.new do |spec|
  spec.name          = "association_accessors"
  spec.version       = AssociationAccessors::VERSION
  spec.authors       = ["Szijjártó Nagy Misu"]
  spec.email         = ["szijjartonagy.misu@gmail.com"]

  spec.summary       = 'Handling AR associations with other attributes than primary key'
  spec.description   = 'Provides association accessors like `Company#user_serials` and `User#company_serial` where `Company.has_many :users` and `User.belongs_to :company`.'
  spec.homepage      = 'https://github.com/SzNagyMisu/association_accessors'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"]    = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -- lib/*`.split("\n") + %w[ README.md LICENSE.txt association_accessors.gemspec ]
  spec.test_files    = `git ls-files -- gemfiles/* spec/*`.split("\n") + %w[ Appraisals Gemfile Rakefile .rspec bin/test ]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activerecord", "~> 5.2"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "appraisal", "~> 2.2"
end
