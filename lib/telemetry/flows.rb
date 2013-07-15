#/usr/bin/env ruby

require 'hashie'

module Telemetry

	# Barchart
	class Barchart < Hashie::Dash
  		property :bars, :default => []
	end

	# Bulletchart
	class Bulletchart < Hashie::Dash
  		property :bulletcharts, :default => []
	end

	# Countdown
	class Countdown < Hashie::Dash
		property :time, :required => true
		property :message, :required => true
	end

	# Gauge
	class Gauge < Hashie::Dash
		property :value, :required => true
		property :value_color
		property :max
		property :range
		property :value_2
		property :value_2_color
		property :value_2_label
	end

	# Graph
	class Graph < Hashie::Dash
		property :renderer
		property :series, :default => []
		property :min_scale
		property :unstack
		property :x_labels
	end

	# Icons
	class Icons < Hashie::Dash
		property :icons, :default => []
	end

	# iFrame
	class Iframe < Hashie::Dash
		property :url, :required => true
	end

	# Log
	class Log < Hashie::Dash
		property :messages, :default => []
	end

	# Map
	class Map < Hashie::Dash
		property :map_type, :required => true
		property :points, :default => []
	end

	# Multigauge
	class Multigauge < Hashie::Dash
		property :gauges, :default => []
	end

	# Multivalue
	class Multigauge < Hashie::Dash
		property :values, :default => []
	end

	# Servers
	class Servers < Hashie::Dash
		property :servers, :default => []
		property :orange
		property :red
	end

	# Status
	class Status < Hashie::Dash
		property :statuses, :default => []
	end

	# Table
	class Table < Hashie::Dash
		property :values, :default => []
		property :headers, :default => []
		property :colors, :default => []
	end

	# Text
	class Text < Hashie::Dash
		property :text, :required => true
		property :alignment
	end

	# Tickertape
	class Tickertape < Hashie::Dash
		property :text, :default => []
	end

	# Timechart
	class Timechart < Hashie::Dash
		property :values, :default => []
		property :type, :required => true
	end

	# Timeline
	class Timeline < Hashie::Dash
		property :values, :default => []
		property :type, :required => true
	end

	# Timeseries
	class Timeseries < Hashie::Dash
		property :value, :required => true
		property :type, :required => true
		property :label, :required => true
		property :color
		property :smoothing
		property :value_type
	end

	# Upstatus
	class Upstatus < Hashie::Dash
		property :up, :default => []
		property :down, :default => []
		property :uptime
		property :last_down
	end

	# Value
	class Value < Hashie::Dash
		property :value, :required => true
		property :color
		property :delta
		property :value_type
		property :delta_type
	end

	class Api
		require 'multi_json'
		require 'net/http'
		require 'uri'

		def self.post(tag, item)
			data = {tag => item.to_hash}
			Telemetry::Api.send(data)
		end

		def self.send(data)
			return unless Telemetry.token
			return unless data.size > 0

			body = MultiJson.dump({:data => data})

			uri = URI("https://data.telemetryapp.com/flows")
			request = Net::HTTP::Post.new(uri.path)
			request.basic_auth(Telemetry.token, "")
			request['Content-Type'] = 'application/json'
			request['User-Agent'] = "Telemetry Ruby Gem (#{Telemetry::TELEMETRY_VERSION})"
			request.body = body 

			begin
				result = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
				  response = http.request(request)
				  case response.code
				 	when "200"
				 		json = MultiJson.load(response.body)
				 		if json
				    		puts "#{Time.now} Update OK: Updated #{json["updated"].count} flows" if json["updated"] && json["updated"].count > 0
				    		puts "#{Time.now} Update OK: Skipped #{json["skipped"].count} flows (#{json["skipped"].join(", ")})" if json["skipped"] && json["skipped"].count > 0
				    		puts "#{Time.now} Update OK: Errors with #{json["errors"].count} flows (#{json["errors"].join(", ")})" if json["errors"] && json["errors"].count > 0
				    	end
				    when "400"
				    	puts "#{Time.now} ERROR 400: Request error. #{response.body}. Exiting."
				    	exit
					when "401"
				    	puts "#{Time.now} ERROR 401: Authentication failed, please check your api_token. Exiting."
				    	exit
				    when "403"
				    	puts "#{Time.now} ERROR 403: Authorization failed, please check your account access. Exiting."
				    	exit
				    when "429"
				    	puts "#{Time.now} ERROR 429: Rate limited. Please reduce your update interval. Pausing updates for 300s."
				    	sleep 300
				    when "500"
				    	puts "#{Time.now} ERROR 500: Data API server error.  Pausing updates for 60s."
				    	sleep 60
				    when "503"
				    	puts "#{Time.now} ERROR 503: Data API server is down.  Pausing updates for 60s."
				    	sleep 60
				    else
				    	puts "#{Time.now} ERROR UNK: #{response.body}.  Exiting."
				    	exit
				  	end
				end

			rescue Errno::ETIMEDOUT => e
				puts "#{Time.now} ERROR #{e}"
				sleep 60

			rescue Errno::ECONNREFUSED => e 
				puts "#{Time.now} ERROR #{e}"
				sleep 60

			rescue Exception => e
				puts "#{Time.now} ERROR #{e}"
				sleep 60
			end
		end
	end
end
