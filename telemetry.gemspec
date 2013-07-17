# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telemetry/version'

Gem::Specification.new do |gem|
  gem.name          = "telemetry"
  gem.version       = Telemetry::TELEMETRY_VERSION
  gem.authors       = ["W. Gersham Meharg"]
  gem.email         = ["gersham@etosi.com"]
  gem.description   = %q{Telemetry Data Submission API Gem.  See our website for a more detailed description.}
  gem.summary       = %q{Telemetry Data Submission API Gem}
  gem.homepage      = "http://www.telemetryapp.com"
  gem.license = 'MIT'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency "oj"
  gem.add_dependency "multi_json"
  gem.add_dependency "dante"
  gem.add_dependency "hashie"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
end
