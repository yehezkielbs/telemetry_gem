#!/usr/bin/env ruby

module TelemetryDaemon

	def api_host(api_host)
		Telemetry.api_host = api_host
	end

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

  @@flows_expire_in = nil
	def flows_expire_in(i)
		@@flows_expire_in = i
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

  def box(tag, frequency = 0, offset=nil, &block)
    @@tasks ||= []
    @@tasks << [ :countdown, tag, frequency, offset, block ]
  end

  def clock(tag, frequency = 0, offset=nil, &block)
    @@tasks ||= []
    @@tasks << [ :countdown, tag, frequency, offset, block ]
  end

  def countdown(tag, frequency = 0, offset=nil, &block)
    @@tasks ||= []
    @@tasks << [ :countdown, tag, frequency, offset, block ]
  end

  def compass(tag, frequency = 0, offset=nil, &block)
    @@tasks ||= []
    @@tasks << [ :countdown, tag, frequency, offset, block ]
  end

	def custom(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :custom, tag, frequency, offset, block ]
	end

	def funnelchart(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :funnelchart, tag, frequency, offset, block ]
	end

	def gauge(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :gauge, tag, frequency, offset, block ]
	end

	def graph(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :graph, tag, frequency, offset, block ]
	end

	def grid(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :gid, tag, frequency, offset, block ]
	end

	def histogram(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :histogram, tag, frequency, offset, block ]
	end

	def icon(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :icon, tag, frequency, offset, block ]
	end

	def image(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :image, tag, frequency, offset, block ]
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

	def piechart(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :piechart, tag, frequency, offset, block ]
	end

	def scatterplot(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :scatterplot, tag, frequency, offset, block ]
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

	def video(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :value, tag, frequency, offset, block ]
	end

	def waterfall(tag, frequency = 0, offset=nil, &block)
		@@tasks ||= []
		@@tasks << [ :waterfall, tag, frequency, offset, block ]
	end

  def weather(tag, frequency = 0, offset=nil, &block)
    @@tasks ||= []
    @@tasks << [ :countdown, tag, frequency, offset, block ]
  end

	def run_scheduled_flow_updates
		@@buffer = {}
		@@tasks ||= {}
		@@next_run_at ||= {}

		@@tasks.each do |task| 
			@@h = {}
			variant, tag, frequency, offset, block = task
			now = Time.now


			# Check whether we should wait an interval before running
			if frequency > 0 
				Telemetry::logger.debug "Task #{task[0]} #{task[1]} (every #{task[2]}s)"
				#Telemetry::logger.debug "Update frequency is #{frequency} now #{Time.now.to_i} next #{@@next_run_at[tag]}"
				if @@next_run_at[tag] && @@next_run_at[tag] > now.to_i
					Telemetry::logger.debug "  - Not scheduled yet (waiting #{-(now.to_i - @@next_run_at[tag])}s)"
					next
				end
				@@next_run_at[tag] = now.to_i + frequency

				Telemetry::logger.debug "  - Running intermittant task at #{now}"

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
			else
				Telemetry::logger.debug "  - Task #{task[0]} #{task[1]}"
			end

			# Execute the flow
			Telemetry.logger.debug "  + Executing task #{task[0]} #{task[1]}"
			block.yield

			if @@h == {}
				Telemetry.logger.debug "  - Skipping empty task values #{task[0]} #{task[1]}"
				next
			end

      # Use global default to set expires_at field if necessary
			if @@flows_expire_in and not @@h[:expires_at]
        set expires_at: Time.now.to_i + @@flows_expire_in
      end

			# Append the variant
			values = @@h.merge({variant: variant})

			# Telemetry.logger.debug "  - Values for #{task[0]} #{task[1]}:\n#{values}\n#{@@last_values[tag]}"

			# Telemetry.logger.debug "LV\n\n #{@@last_values}\n\n"

			@@buffer[tag] = values
		end

		@@buffer
	end
end

