# Telemetry

This gem provides a wrapper around the Telemetry API (http://www.telemetryapp.com).  

## Installation

Install on your system:

    $ gem install telemetry


## Basic Usage

This gem allows you to interact with the API using simple POST, GET, PATCH, PUT, DELETE. You should use the following methods:

- Telemetry::Api.delete(path) 
- Telemetry::Api.get(path)
- Telemetry::Api.patch(path, body)
- Telemetry::Api.post(path, body)
- Telemetry::Api.put(path, body)

Where __path__ is the path for the resource (for instance "/boards/:board_id") and __body__ is a hash of the body to send to the server.  You do not need to JSON encode the body, it will be converted to JSON for you.

	require 'telemetry'

	Telemetry.token = $YOUR_API_TOKEN
	@board = Telemetry::Api.get("/boards/#{@board_id}")

## Sending Data To a Flow

To use this gem you must require it in your file and specify your API Token that you can find on the [Telemetry API Token page](https://www.telemetryapp.com/account/api_token)

Create a new flow object of the variant that you want to use. Use its emit method to send the data to Telemetry.  

	require 'telemetry'

	Telemetry.token = "test-api-token"
	gauge = Telemetry::Gauge.new(tag: "test-flow-gauge", value: 3434)
	gauge.emit

Supported flow object variants are as follows:

- Telemetry::Barchart
- Telemetry::Bulletchart
- Telemetry::Countdown
- Telemetry::Gauge
- Telemetry::Graph
- Telemetry::Grid
- Telemetry::Icon
- Telemetry::Image
- Telemetry::Log
- Telemetry::Multigauge
- Telemetry::Multivalue
- Telemetry::Piechart
- Telemetry::Scatterplot
- Telemetry::Servers
- Telemetry::Status
- Telemetry::Table
- Telemetry::Text
- Telemetry::Tickertape
- Telemetry::Timechart
- Telemetry::Timeline
- Telemetry::Upstatus
- Telemetry::Value
- Telemetry::Waterfall

For documentation on the different properties for the various data elements please see the [data documentation](https://www.telemetryapp.com/user/documentation/data) pages.

## Batch Updating Multiple Flows at Once

You may send data to more than one flow in a single API call.  To do this construct an array of flows and use the Telemetry::Api.flow_update_batch(flows) method. A code example follows:

	require 'telemetry'

	Telemetry.token = "test-api-token"
	flows = []
	flows << Telemetry::Value.new({tag: "test-flow-value", value: 3432})
	flows << Telemetry::Gauge.new({tag: "test-flow-gauge", value: 33})
	Telemetry::Api.flow_update_batch(flows)

## Data Encryption

While Telemetry is SSL based and we protect our customers data with utmost caution, some corporate policies will not approve of any third party having the possibility of access to their data.  Therefore we support optional encryption of the data with AES-256-CBC before sending it to the Telemetry API.   The Telemetry Javascript application that runs in your browser to view the data can be configured with the same key in order to decrypt the data and display it for you while making it invisible to any prying eyes in the middle.  

	require 'telemetry'

	Telemetry.token = "test-api-token"
	ENCRYPTIONKEY = "Unique Random Password"
	flow = Telemetry::Value.new(tag: "test-flow-value", value: 3434)
	flow.encrypt(ENCRYPTIONKEY)  
	flow.emit

Please be careful that your data isn't able to be validated by the Telemetry API since it cannot see it.  Therefore we suggest testing with dummy uncrypted data first.  Additionally there will be performance implications for large amounts of changing data for some browsers. 

In order to view encrypted data in your browser you will need to append the key to the end of the URL by adding it like the following: 

	https://boards.telemetryapp.com/board.html?channel_id=467177c0126e4d8d4809c2414b995e01#encryption_key=ENCRYPTIONKEY

Note that the # part will not be sent to the server, it's a local argument only visible to the local javascript running in the browser.  Certain attributes like tags and priority will not be encrypted as they're needed by the system. 

## Virtual Channels

This gem supports virtual channel sending.  You must have a pro or higher account to use virtual channels.  In order to use this you must call:

-	Telemetry::Api.channel_send(unique-identifier, flow)
-	Telemetry::Api.channel_send_batch(unique-identifier, flows) 

An example of code to do this would be:

	require 'telemetry'

	Telemetry.token = "test-api-token"
	flow = Telemetry::Value.new(tag: "test-flow-value", value: 3434)
	Telemetry::Api.channel_send("channel-tag", flow)

For more information see the [virtual channel documentation](https://www.telemetryapp.com/user/documentation/virtual_channels).

## Affiliates

This gem supports affiliate data sending. You must have an enterprise account and get support to enable your account for affiliates first. In order to use this capability call either:

-	Telemetry::Api.affiliate_send(affiliate-identifier, flow)
-	Telemetry::Api.affiliate_send_batch(affiliate-identifier, flows) 

An example of code to do this would be:

	require 'telemetry'

	Telemetry.token = "test-api-token"
	flow = Telemetry::Value.new(tag: "test-flow-value", value: 3434)
	Telemetry::Api.affiliate_send("affiliate-identifier", flow)

For more information see the [affiliate documentation](https://admin.telemetryapp.com/user/documentation/affiliates).

## Aggregations

This gem supports the aggregations API interface.  Aggregations allow you to send data point by point and have Telemetry aggregate the data for you.  The gem supports the following methods:

-	Telemetry::Api.aggregate(bucket, value)
-	Telemetry::Api.aggregate_set_interval(bucket, interval, values) 

An example of code to do this would be:

	require 'telemetry'

	Telemetry.token = "test-api-token"
	Telemetry::Api.aggregate("my-bucket", 23124)

For more infromation see the [aggregations documentation](https://admin.telemetryapp.com/user/documentation/aggregations)

## Daemon

Telemetry also supports a daemon mode where a binary (telemetryd) runs indefintely and loops through a configuration file triggering updates to the API as it goes.

Create a config file on your disk (by default /etc/telemetryd_config.rb).  This file may have ruby code in it,  you may include your own gems, etc.  The file supports three configuration directives "interval", "api_token" and "flows_expire_in".  The interval is how frequently each flow block is executed with the results sent to the server.  The flows_expire_in sets the expiry timout of the flows. If they do not get fresh data before that period of time the board will display and expired logo on their widgets. Please note if the result from a block is unchanged from the previous execution then it will be sent to the server only once per day when flows_expire_in is not set. 

For more details please see our website.

Example simple config:

	interval 5            
	flows_expire_in 300
	api_token "test-api-token"

	gauge "test-flow-gauge" do
		set value: 45
		set max: 100
	end

To start the daemon daemonized:

	$ telemetryd.rb -d

To kill the daemon:

	$ telemetryd.rb -k

Omitting the -d will start the process in the foreground and log to stdout.  This is useful for debugging your config file.   The daemon can be started with -o to run once and exit.

Custom update intervals are supported on a per flow basis.  To configure the update interval append an integer with the number of seconds to update as per the following:

	gauge "test-flow-gauge", 86400 do
		set value: 50
	end

Deamon mode does not currently support encrypting values.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
