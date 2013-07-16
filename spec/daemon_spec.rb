require 'spec_helper'
require_relative "../lib/telemetry/daemon_config_parser"

describe "Daemon" do
	before(:all) do
		Telemetry.token = "test-api-token"
	end

    it "should run the daemon" do
    	`bin/telemetryd -c telemetryd_config.rb -o`
	end
end