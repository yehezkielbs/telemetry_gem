require 'spec_helper'

describe "Flows" do
  before(:all) do
  	Telemetry.token = "test-api-token"
  end

  it "should update a Barchart", flows: true do
  	properties = {
  		tag: "test-flow-barchart",
  		bars: [{value:1000, label:'test', color:'red'}]
  	}
  	Telemetry::Barchart.new(properties).emit
  end

  it "should update a Bulletchart", flows: true  do
  	properties = {
  		tag: "test-flow-bulletchart",
  		bulletcharts: [{value: 34, max: 4434}]
  	}
  	Telemetry::Bulletchart.new(properties).emit
  end

  it "should update a Countdown", flows: true  do
  	properties = {
  		tag: "test-flow-countdown",
  		time: 1373664109, 
  		message: "Party Time"
  	}
  	Telemetry::Countdown.new(properties).emit
  end

  it "should update a Gauge" do
  	properties = {
  		tag: "test-flow-gauge",
  		value: 3434
  	}
  	Telemetry::Gauge.new(properties).emit
  end

  it "should update a Graph" do
  	properties = {
  		tag: "test-flow-graph",
  		series: [{values:[4,3,53,3,54,33,21]}]
  	}
  	Telemetry::Graph.new(properties).emit
  end

  it "should update a Icon" do
  	properties = {
  		tag: "test-flow-icon",
  		icons: [{type: "icon-dashboard", label: "Alert", color: "red"}]
  	}
  	Telemetry::Icon.new(properties).emit
  end

  it "should update a Log" do
  	properties = {
  		tag: "test-flow-log",
  		messages: [{timestamp: 1373664109, text: "This is a first message", color: "red"}]
  	}
  	Telemetry::Log.new(properties).emit
  end


  it "should update a Multigauge" do
  	properties = {
  		tag: "test-flow-multigauge",
  		gauges: [{value: 34, label: "Alpha"},{value: 23, label: "Alpha"}]
  	}
  	Telemetry::Multigauge.new(properties).emit
  end

  it "should update a Multivalue" do
  	properties = {
  		tag: "test-flow-multivalue",
  		values: [{value: 34, label: "Alpha"},{value: 344, label: "Bravo"}]
  	}
  	Telemetry::Multivalue.new(properties).emit
  end

  it "should update a Servers" do
  	properties = {
  		tag: "test-flow-servers",
  		servers: [{values: [33,22,55], name: "Alpha"}]
  	}
  	Telemetry::Servers.new(properties).emit
  end

  it "should update a Status" do
  	properties = {
  		tag: "test-flow-status",
  		statuses: [{label: "Alpha", color: "red"}]
  	}
  	Telemetry::Status.new(properties).emit
  end

  it "should update a Table" do
  	properties = {
  		tag: "test-flow-table",
  		table: [["Row1Col1", "Row1Col2", "Row1Col3"]]
  	}
  	Telemetry::Table.new(properties).emit
  end

  it "should update a Text" do
  	properties = {
  		tag: "test-flow-text",
  		text: "testing"
  	}
  	Telemetry::Text.new(properties).emit
  end

  it "should update a Tickertape" do
  	properties = {
  		tag: "test-flow-tickertape",
  		messages: ["Hello World!"]
  	}
  	Telemetry::Tickertape.new(properties).emit
  end

  it "should update a Timeline" do
  	properties = {
  		tag: "test-flow-timeline",
  		messages: [{timestamp: 1373665284, from: "Telemetry", text: "This is the second message"}]
  	}
  	Telemetry::Timeline.new(properties).emit
  end

   it "should update a Timeseries" do
  	properties = {
      tag: "test-flow-timeseries",
      value: 33, 
      aggregation: "average", 
      interval: "seconds" 		
   	}
  	Telemetry::Timeseries.new(properties).emit
  end

  it "should update a Upstatus" do
  	properties = {
      tag: "test-flow-upstatus",
      up: ["www.telemetryapp.com"] 		
   	}
  	Telemetry::Upstatus.new(properties).emit
  end

  it "should update a Value" do
  	properties = {
  		tag: "test-flow-value",
  		value: 3434
   	}
  	Telemetry::Value.new(properties).emit
  end

end

