# Telemetry

This gem provides a wrapper around the Telemetry API (http://www.telemetryapp.com).  

## Installation

Install on your system:

    $ gem install telemetry

## Basic Usage

To use this gem you must require it in your file and specify your API Token that you can find on the [Telemetry API Token page](https://admin.telemetryapp.com/account/api_token)

Set a hash of values for the flow to update.  Each hash must contain the tag of the flow that you want to update.  

	require 'telemetry'

	Telemetry.token = "test-api-token"

	properties = {
		tag: "test-flow-value",
		value: 3434
	}
	Telemetry::Value.new(properties).emit

For documentation on flows and the properties they support please see the [flow documentation](https://admin.telemetryapp.com/documentation/flows) pages.


## Daemon

Telemetry also supports a daemon mode where a binary (telemetryd) runs indefintely and loops through a configuration file triggering updates to the API as it goes.

Create a config file on your disk (by default /etc/telemetryd_config.rb).  This file may have ruby code in it,  you may include your own gems, etc.  The file supports two configuration directives "interval" and "api_token".  The interval is how frequently each flow block is executed with the results sent to the server.  Please note if the result from a block is unchanged from the previous execution then it will be sent to the server only once per day. 

For more details please see our website.

Example simple config:

	interval 5
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
