#/usr/bin/env ruby

require 'multi_json'
require 'oj'
require 'net/http'
require 'uri'
require 'logger'

module Telemetry

	@affiliate_id
	@token = nil

	def self.api_host
		if ENV["RACK_ENV"] == 'development' || ENV["RACK_ENV"] == 'test'
			"http://data.test.telemetryapp.com"
		else
			"https://data.telemetryapp.com"
		end
	end

	def self.logger
		@logger ||= Logger.new(STDOUT)
		if ENV['RACK_ENV'] == 'development'
			@logger.level = Logger::DEBUG
		else
			@logger.level = Logger::WARN
		end
		@logger
	end

	def self.token
		@token
	end

	def self.token=(token)
		@token = token
	end

	def self.affiliate_id
		@token
	end

	def self.affiliate_id=(affiliate_id)
		@affiliate_id = affiliate_id
	end

	class Api
		
		def self.get_flow(id)
			Telemetry::Api.send(:get, "/flows/#{id}")
		end

		def self.get_flow_data(id)
			Telemetry::Api.send(:get, "/flows/#{id}/data")
		end

		def self.delete_flow_data(id)
			Telemetry::Api.send(:delete, "/flows/#{id}/data")
		end

		def self.flow_update(flow)
			raise Telemetry::AuthenticationFailed, "Please set your Telemetry.token" unless Telemetry.token
			values = flow.to_hash
			tag = values.delete('tag')
			result = Telemetry::Api.send(:put, "/flows/#{tag}", values)
			raise ResponseError, "API Response: #{result['errors'].join(', ')}" unless result["updated"].include?(tag)
			result
		end

		def self.flow_update_batch(flows)
			raise Telemetry::AuthenticationFailed, "Please set your Telemetry.token" unless Telemetry.token
			raise RuntimeError, "Must supply flows to send" if flows == 0 || flows.count == 0
			data = {}
			flows.each do |flow|
				values = flow.to_hash
				tag = values.delete('tag')
				data[tag] = values
			end
			return Telemetry::Api.send(:post, "/flows", {:data => data})
		end

		def self.send(method, endpoint, data = nil)

			uri = URI("#{Telemetry.api_host}#{endpoint}")

			Telemetry::logger.debug "REQ #{uri} - #{MultiJson.dump(data)}"

			if method == :post
				request = Net::HTTP::Post.new(uri.path)
				request.body = MultiJson.dump(data) 
			elsif method == :put
				request = Net::HTTP::Put.new(uri.path)
				request.body = MultiJson.dump(data) 
			elsif method == :get 
				request = Net::HTTP::Get.new(uri.path)
			elsif method == :delete
				request = Net::HTTP::Delete.new(uri.path)
			end

			request.basic_auth(Telemetry.token, "") if Telemetry.token
			request['Content-Type'] = 'application/json'
			request['Accept-Version'] = '~ 1'
			request['User-Agent'] = "Telemetry Ruby Gem (#{Telemetry::TELEMETRY_VERSION})"
				
			begin
				ssl = true if Telemetry.api_host.match(/^https/)
				result = Net::HTTP.start(uri.host, uri.port, :use_ssl => ssl) do |http|
					response = http.request(request)
					code = response.code

					Telemetry::logger.debug "RESP: #{response.code}:#{response.body}"

					case response.code
					when "200"
						return MultiJson.load(response.body)
					when "400"
						json = MultiJson.load(response.body)
						error = "#{Time.now} (HTTP 400): #{json['code'] if json} #{json['message'] if json}"
						Telemetry::logger.error error
						raise Telemetry::FormatError, error
					when "401"
						if Telemetry.token == nil
							error = "#{Time.now} (HTTP 401): Authentication failed, please set Telemetry.token to your API Token."
							Telemetry::logger.error error
							raise Telemetry::AuthenticationFailed, error
						else
							error = "#{Time.now} (HTTP 401): Authentication failed, please verify your token."
							Telemetry::logger.error error
							raise Telemetry::AuthenticationFailed, error
						end
					when "403"
						error = "#{Time.now} (HTTP 403): Authorization failed, please check your account access."
						Telemetry::logger.error error
						raise Telemetry::AuthorizationError, error
					when "404"
						error = "#{Time.now} (HTTP 404): Requested object not found."
						Telemetry::logger.error error
						raise Telemetry::FlowNotFound, error
					when "429"
						error = "#{Time.now} (HTTP 429): Rate limited. Please reduce your update interval."
						Telemetry::logger.error error
						raise Telemetry::RateLimited, error
					when "500"
						error = "#{Time.now} (HTTP 500): Data API server error."
						Telemetry::logger.error error
						raise Telemetry::ServerException, error
					when "502"
						error = "#{Time.now} (HTTP 502): Data API server is down."
						Telemetry::logger.error error
						raise Telemetry::Unavailable, error
					when "503"
						error = "#{Time.now} (HTTP 503): Data API server is down."
						Telemetry::logger.error error
						raise Telemetry::Unavailable, error
					else
						error = "#{Time.now} ERROR UNK: #{response.body}."
						raise Telemetry::UnknownError, error
					end
				end

			rescue Errno::ETIMEDOUT => e
				error = "#{Time.now} ERROR #{e}"
				Telemetry::logger.error error
				raise Telemetry::ConnectionError, error

			rescue Errno::ECONNREFUSED => e 
				error = "#{Time.now} ERROR #{e}"
				Telemetry::logger.error error
				raise Telemetry::ConnectionError, error

			rescue Exception => e
				raise e
			end
		end
	end

	class FormatError < Exception
	end

	class AuthenticationFailed < Exception
	end

	class AuthorizationError < Exception
	end
	
	class FlowNotFound < Exception
	end

	class RateLimited < Exception
	end

	class ServerException < Exception
	end

	class Unavailable < Exception
	end

	class UnknownError < Exception
	end

	class ConnectionError < Exception
	end

	class ResponseError < Exception
	end


end
