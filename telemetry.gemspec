# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telemetry/version'

Gem::Specification.new do |gem|
  gem.name          = "telemetry"
  gem.version       = Telemetry::VERSION
  gem.authors       = ["W. Gersham Meharg"]
  gem.email         = ["gersham@etosi.com"]
  gem.description   = %q{Telemetry Data Submission API Gem.  See our website for a more detailed description.}
  gem.summary       = %q{Telemetry Data Submission API Gem}
  gem.homepage      = "http://www.telemetryapp.com"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency "oj"
  gem.add_dependency "multi_json"
  gem.add_dependency "dante"
end
