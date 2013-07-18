#!/usr/bin/env ruby

module Telemetry

	def api_token(token)
		Telemetry.token = token
	end

	def log_level(log_level)
		level = log_level.to_s
		if log_level == 'debug'
			Telemetry.logger.level = Logger::DEBUG
			Telemetry.logger.debug "Starting Debug Logging" 
		end
	end

	def interval(interval)
		@@interval = interval
	end

	# Ensure a minimum of 1 second between loops
	def wait_for_interval_from(timestamp)
		@@interval ||= 60
		@@interval = 1.0 if @@interval < 1
		sleep_length = timestamp + @@interval.to_f - Time.now.to_f
		sleep sleep_length if sleep_length > 0
	end

 	def set_json(x)
 		x.each {|k,v| @@h[k.to_sym] = MultiJson.load(v)}
 	end

 	def set(x)
 		x.each {|k,v| @@h[k.to_sym] = v}
 	end

  	# Code blocks users can call at the beginning and end of each interval
  	@@begin_interval = nil
  	@@end_interval = nil

 	def begin_interval(&block)
 		@@begin_interval = block
 	end

 	def run_begin_interval
 		@@begin_interval.yield if @@begin_interval
 	end

 	def end_interval(&block)
 		@@end_interval = block
 	end

 	def run_end_interval
 		@@end_interval.yield if @@end_interval
 	end

	def barchart(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :barchart, tag, frequency, offset, block ]
	end

	def bulletchart(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :value, tag, frequency, offset, block ]
	end

	def countdown(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :countdown, tag, frequency, offset, block ]
	end

	def gauge(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :gauge, tag, frequency, offset, block ]
	end

	def graph(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :graph, tag, frequency, offset, block ]
	end

	def icon(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :icon, tag, frequency, offset, block ]
	end

	def iframe(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :iframe, tag, frequency, offset, block ]
	end

	def log(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :log, tag, frequency, offset, block ]
	end

	def map(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :map, tag, frequency, offset, block ]
	end

	def multigauge(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :multigauge, tag, frequency, offset, block ]
	end

	def multivalue(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :multivalue, tag, frequency, offset, block ]
	end

	def servers(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :servers, tag, frequency, offset, block ]
	end

	def status(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :servers, tag, frequency, offset, block ]
	end

	def table(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :table, tag, frequency, offset, block ]
	end

	def text(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :text, tag, frequency, offset, block ]
	end

	def tickertape(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :tickertape, tag, frequency, offset, block ]
	end

	def timechart(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :timechart, tag, frequency, offset, block ]
	end

	def timeline(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :timeline, tag, frequency, offset, block ]
	end

	def timeseries(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :timeseries, tag, frequency, offset, block ]
	end

	def upstatus(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :upstatus, tag, frequency, offset, block ]
	end

	def value(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :value, tag, frequency, offset, block ]
	end

	def run_scheduled_flow_updates
		@@buffer = {}
		@@tasks ||= {}
		@@last_values ||= {}
		@@values_expires_at ||= {}
		@@next_run_at ||= {}

		@@tasks.each do |task| 
			@@h = {}
			variant, tag, frequency, offset, block = task
			now = Time.now

			# Check whether we should wait an interval before running
			if frequency > 0 
				#Telemetry::logger.debug "Update frequency is #{frequency} now #{Time.now.to_i} next #{@@next_run_at[tag]}"
				next if @@next_run_at[tag] && @@next_run_at[tag] >= now.to_i
				@@next_run_at[tag] = now.to_i + frequency

		        # If an offset is defined then align runtimes to the offset
		        # How close you can get to the desired offset depends on the global interval. So set it relatively small
		        # when using this feature
				if offset and offset >= 0 and offset <= 86400
					this_morning = Time.new(now.year, now.month, now.day).to_i
					time_since_offset = now.to_i - this_morning - offset
					time_since_offset += 86400 if time_since_offset < 0

					@@next_run_at[tag] -= time_since_offset % frequency
					#Telemetry::logger.debug "#{now.to_i} #{@@next_run_at[tag]}"
				end
			end

			# Execute the flow
			block.yield

			next if @hh == {}

			# Append the variant
			values = @@h.merge({variant: variant})

			# Skip if the values haven't changed (though send 1/day regardless)
			if @@last_values[tag] != values || @@values_expires_at[tag] < now.to_i
				@@buffer[tag] = values
				@@last_values[tag] = values # Save the value so we dont update unless it changes
				@@values_expires_at[tag] = now.to_i + 86400  # Force an update 1/day
			end
		end

		@@buffer
	end
end

