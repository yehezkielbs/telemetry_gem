#!/usr/bin/env ruby

module Telemetry

	def token
		@@token
	end

	def api_token(token)
		@@token = token
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

	def barchart(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :barchart, tag, frequency, block ]
	end

	def countdown(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :countdown, tag, frequency, block ]
	end

	def gauge(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :gauge, tag, frequency, block ]
	end

	def graph(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :graph, tag, frequency, block ]
	end

	def icon(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :icon, tag, frequency, block ]
	end

	def iframe(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :iframe, tag, frequency, block ]
	end

	def log(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :log, tag, frequency, block ]
	end

	def map(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :map, tag, frequency, block ]
	end

	def multigauge(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :multigauge, tag, frequency, block ]
	end

	def multivalue(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :multivalue, tag, frequency, block ]
	end

	def servers(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :servers, tag, frequency, block ]
	end

	def table(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :table, tag, frequency, block ]
	end

	def text(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :text, tag, frequency, block ]
	end

	def tickertape(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :tickertape, tag, frequency, block ]
	end

	def timechart(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :timechart, tag, frequency, block ]
	end

	def timeline(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :timeline, tag, frequency, block ]
	end

	def timeseries(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :timeseries, tag, frequency, block ]
	end

	def upstatus(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :upstatus, tag, frequency, block ]
	end

	def value(tag, frequency = 0, &block)
		@@tasks ||= []
		@@tasks << [ :value, tag, frequency, block ]
	end

	def run_scheduled_flow_updates
		@@buffer = {}
		@@tasks ||= {}
		@@last_values ||= {}
		@@values_expires_at ||= {}
		@@next_run_at ||= {}

		@@tasks.each do |task| 
			@@h = {}
			variant, tag, frequency, block = task

			# Check whether we should wait an interval before running
			if frequency > 0 
				#puts "Frequency is #{frequency} now #{Time.now.to_i} next #{@@next_run_at[tag]}"
				next if @@next_run_at[tag] && @@next_run_at[tag] >= Time.now.to_i
				@@next_run_at[tag] = Time.now.to_i + frequency.to_i
			end

			# Execute the flow
			block.yield

			next if @hh == {}

			# Append the variant
			values = @@h.merge({variant: variant})

			# Skip if the values haven't changed (though send 1/day regardless)
			if @@last_values[tag] != values || @@values_expires_at[tag] < Time.now.to_i
				@@buffer[tag] = values
				@@last_values[tag] = values # Save the value so we dont update unless it changes
				@@values_expires_at[tag] = Time.now.to_i + 86400  # Force an update 1/day
			end
		end

		@@buffer
	end
end

