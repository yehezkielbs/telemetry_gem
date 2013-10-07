#/usr/bin/env ruby

require 'hashie'

module TelemetryFlows
	def emit
		Telemetry::Api.flow_update(self)
	end
end

module Telemetry

	# Barchart
	class Barchart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
  	property :bars, :default => []
	end

	# Bulletchart
	class Bulletchart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
  	property :bulletcharts, :default => []
	end

	# Countdown
	class Countdown < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :time, :required => true
		property :message, :required => true
	end

	# Gauge
	class Gauge < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :value, :required => true
		property :value_color
		property :max
		property :range
		property :value_2
		property :value_2_color
		property :value_2_label
		property :value_type
	end

	# Graph
	class Graph < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :renderer
		property :series, :default => []
		property :min_scale
		property :unstack
		property :x_labels
	end

	# Icons
	class Icon < Hashie::Dash
		include TelemetryFlows
		property :title
		property :expires_at
		property :priority
		property :icon
		property :tag, :required => true
		property :icons, :default => []
	end

	# iFrame
	class Iframe < Hashie::Dash
		include TelemetryFlows
		property :title
		property :expires_at
		property :priority
		property :icon
		property :tag, :required => true
		property :url, :required => true
	end

	# Log
	class Log < Hashie::Dash
		include TelemetryFlows
		property :title
		property :expires_at
		property :priority
		property :icon
		property :tag, :required => true
		property :messages, :default => []
	end

	# Map
	class Map < Hashie::Dash
		include TelemetryFlows
		property :title
		property :expires_at
		property :priority
		property :icon
		property :tag, :required => true
		property :map_type, :required => true
		property :points, :default => []
	end

	# Multigauge
	class Multigauge < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :expires_at
		property :priority
		property :icon
		property :title
		property :gauges, :default => []
	end

	# Multivalue
	class Multivalue < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :expires_at
		property :priority
		property :icon
		property :title
		property :values, :default => []
	end

	# Servers
	class Servers < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :servers, :default => []
		property :orange
		property :red
	end

	# Status
	class Status < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :statuses, :default => []
	end

	# Table
	class Table < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :table, :default => []
		property :headers, :default => []
		property :colors, :default => []
	end

	# Text
	class Text < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :text, :required => true
		property :alignment
	end

	# Tickertape
	class Tickertape < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :messages, :default => []
	end

	# Timechart
	class Timechart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :values, :default => []
		property :type, :required => true
	end

	# Timeline
	class Timeline < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :messages, :default => []
	end

	# Timeseries
	class Timeseries < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :value, :required => true
		property :type, :required => true
		property :label, :required => true
		property :color
		property :smoothing
		property :value_type
	end

	# Upstatus
	class Upstatus < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :up, :default => []
		property :down, :default => []
		property :uptime
		property :last_down
	end

	# Value
	class Value < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
		property :expires_at
		property :priority
		property :icon
		property :value, :required => true
		property :color
		property :delta
		property :value_type
		property :delta_type
		property :sparkline
		property :label
	end
end