# Telemetry

This gem provides a wrapper around the Telemetry API (http://www.telemetryapp.com).  

## Installation

Install on your system:

    $ gem install telemetry

## Usage

Create a config file on your disk (by default /etc/telemetryd_config.rb).  This file may have ruby code in it,  you may include your own gems, etc.  The file supports two configuration directives "interval" and "api_token".  The interval is how frequently each flow block is executed with the results sent to the server.  Please note if the result from a block is unchanged from the previous execution then it will be sent to the server only once per day. 

For more details please see our website.

Example simple config:

	interval 5
	api_token "c65bc385a3b30135590a80973483ebf"

	gauge "my-gauge" do
		set value: 45
		set max: 100
	end

To start the daemon daemonized:

	$ telemetryd.rb -d

To kill the daemon:

	$ telemetryd.rb -k

Omitting the -d will start the process in the foreground and log to stdout.  This is useful for debugging your config file. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
