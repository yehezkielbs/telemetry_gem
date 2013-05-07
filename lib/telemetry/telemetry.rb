#/usr/bin/env ruby

module Telemetry
	class Api
		require 'multi_json'
		require 'net/http'
		require 'uri'

		def self.send(data)
			return unless Telemetry.token
			return unless data.size > 0

			body = MultiJson.dump({:data => data})

			uri = URI("https://data.telemetryapp.com/v1/data.json")
			request = Net::HTTP::Post.new(uri.path)
			request.basic_auth(Telemetry.token, "")
			request['Content-Type'] = 'application/json'
			request['User-Agent'] = "telemetryd"
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
