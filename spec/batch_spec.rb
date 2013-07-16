require 'spec_helper'

describe "Batch" do
	before(:all) do
		Telemetry.token = "test-api-token"
		Telemetry.api_host = "http://data.test.telemetryapp.com"
	end

	# it "should perform a batch update" do

	# 	flows = []

	# 	barchart_properties = {
	# 		tag: "test-flow-barchart",
	# 		bars: [{value:1000, label:'test', color:'red'}]
	# 	}
	# 	flows << Telemetry::Barchart.new(barchart_properties)

	# 	gauge_properties = {
	# 		tag: "test-flow-gauge",
	# 		value: 3434
	# 	}
	# 	flows << Telemetry::Gauge.new(gauge_properties)

	# 	value_properties = {
	# 		tag: "test-flow-value",
	# 		value: 3434
	# 	}
	# 	flows << Telemetry::Value.new(value_properties)

	# 	result = Telemetry::Api.flow_update_batch(flows)

	# 	result["skipped"].should eql([])
	# 	result["errors"].should eql([])
	# end
end