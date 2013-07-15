require "rubygems"
require "bundler/setup"

require_relative "telemetry/version"
require_relative "telemetry/flows"
require_relative "telemetry/api"

module Telemetry

	@token = 'blah'

	def self.token
		return 'foo'
	end

end