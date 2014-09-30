#/usr/bin/env ruby

require 'hashie'
require 'multi_json'

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
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
    property :min
    property :max
    property :sort
  	property :bars, :default => []
	end

  # Bulletchart
  class Box < Hashie::Dash
    include TelemetryFlows
    property :tag, :required => true
    property :title
    property :opacity
    property :expires_at
    property :priority
    property :icon
    property :link
  end

	# Bulletchart
	class Bulletchart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
  	property :bulletcharts, :default => []
	end

  # Clock
  class Clock < Hashie::Dash
    include TelemetryFlows
    property :tag, :required => true
    property :title
    property :opacity
    property :expires_at
    property :priority
    property :icon
    property :link
    property :style
    property :timezone
  end

	# Countdown
	class Countdown < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :time, :required => true
		property :message, :required => true
	end

  # Compass
  class Compass < Hashie::Dash
    include TelemetryFlows
    property :tag, :required => true
    property :title
    property :opacity
    property :expires_at
    property :priority
    property :icon
    property :label
    property :renderer
    property :heading, :required => true
  end

	# Custom
	class Custom < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :data, :required => true
	end

	# Funnel Chart
	class Funnelchart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :values, :required => true
	end

	# Gauge
	class Gauge < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
    property :label
		property :value, :required => true
		property :value_color
    property :min
    property :max
		property :gauge_color
    property :renderer
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
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :renderer
		property :series, :default => []
		property :min_scale
		property :unstack
		property :x_labels
		property :label
		property :label_2
		property :label_3
    property :start_time
    property :end_time
    property :baseline
    property :value_type
	end

	# Grid
	class Grid < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :data, :required => true
	end

	# Histogram
	class Histogram < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :values, :required => true
		property :colors
		property :widths
		property :y_label
		property :x_label
		property :cumulative
	end

	# Icon
	class Icon < Hashie::Dash
		include TelemetryFlows
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :tag, :required => true
		property :icons, :default => []
	end

	# Image
	class Image < Hashie::Dash
		include TelemetryFlows
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :mode
		property :tag, :required => true
		property :url, :required => true
	end

	# iFrame
	class Iframe < Hashie::Dash
		include TelemetryFlows
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :tag, :required => true
		property :url, :required => true
	end

	# Log
	class Log < Hashie::Dash
		include TelemetryFlows
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :tag, :required => true
		property :messages, :default => []
	end

	# Map
	class Map < Hashie::Dash
		include TelemetryFlows
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :type
		property :mapbox_id
		property :coordinates, :required => true
		property :markers
		property :polylines
		property :polygons
		property :circles
	end

	# Multigauge
	class Multigauge < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :expires_at
		property :priority
		property :icon
		property :gauge_color
		property :link
		property :title
    property :opacity
		property :layout
		property :gauges, :default => []
	end

	# Multivalue
	class Multivalue < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :expires_at
		property :priority
		property :icon
		property :link
		property :title
    property :opacity
		property :values, :default => []
	end

	# Piechart
	class Piechart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :values, :required => true
		property :labels
		property :colors
		property :renderer
	end

	# Scatterplot
	class Scatterplot < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :values, :required => true
		property :color
		property :x_label
		property :y_label
	end


	# Servers
	class Servers < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :servers, :default => []
		property :orange
		property :red
	end

	# Status
	class Status < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :statuses, :default => []
	end

	# Table
	class Table < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :cells, :default => []
		property :table, :default => []
		property :values, :default => []
		property :headers, :default => []
		property :colors, :default => []
	end

	# Text
	class Text < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :text, :required => true
		property :alignment
	end

	# Tickertape
	class Tickertape < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :messages, :default => []
	end

	# Timechart
	class Timechart < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :values, :default => []
		property :type, :required => true
	end

	# Timeline
	class Timeline < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :messages, :default => []
	end

	# Timeseries
	class Timeseries < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :baseline
		property :interval
		property :interval_count
		property :renderer
		property :series_metadata
		property :values
	end

	# Upstatus
	class Upstatus < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :up, :default => []
		property :down, :default => []
		property :uptime
		property :last_down
	end

	# Video
	class Video < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :mode
    property :mp4
    property :muted
    property :ogg
    property :poster
    property :webm
	end

	# Value
	class Value < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :label_color
		property :link
		property :value, :required => true
		property :color
		property :delta
		property :value_type
		property :delta_type
		property :sparkline
		property :label
		property :rounding
		property :abbreviate, :default => true
	end

	# Waterfall
	class Waterfall < Hashie::Dash
		include TelemetryFlows
		property :tag, :required => true
		property :title
    property :opacity
		property :expires_at
		property :priority
		property :icon
		property :link
		property :serial, :required => true
		property :values, :required => true
		property :value_type
		property :spread
	end

  # Weather
  class Weather < Hashie::Dash
    include TelemetryFlows
    property :tag, :required => true
    property :title
    property :opacity
    property :expires_at
    property :priority
    property :icon
    property :location, :required => true
    property :temperature
  end

end