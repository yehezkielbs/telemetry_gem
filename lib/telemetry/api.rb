#/usr/bin/env ruby

require 'multi_json'
require 'oj'
require 'net/http'
require 'uri'

module Telemetry

	@affiliate_id
	@token = nil
	@api_host = "https://data.telemetryapp.com"

	def self.api_host
		@api_host
	end

	def self.api_host=(api_host)
		@api_host = api_host
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
			puts "doing #{tag}"
			result = Telemetry::Api.send(:put, "/flows/#{tag}", values)
			raise ResponseError, "API Response: #{result['errors'].join(', ')}" unless result["updated"].include?(tag)
		end

		def self.flow_update_batch(flows)
			raise Telemetry::AuthenticationFailed, "Please set your Telemetry.token" unless Telemetry.token
			raise RuntimeError, "Must supply flows to send" if items == 0 || items.count == 0
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

					case response.code
					when "200"
						return MultiJson.load(response.body)
					when "400"
						json = MultiJson.load(response.body)
						raise Telemetry::FormatError, "#{Time.now} (HTTP 400): #{json['code'] if json} #{json['message'] if json}"
					when "401"
						if Telemetry.token == nil
							raise Telemetry::AuthenticationFailed, "#{Time.now} (HTTP 401): Authentication failed, please set Telemetry.token to your API Token."
						else
							raise Telemetry::AuthenticationFailed, "#{Time.now} (HTTP 401): Authentication failed, please verify your token."
						end
					when "403"
						raise Telemetry::AuthorizationError, "#{Time.now} (HTTP 403): Authorization failed, please check your account access."
					when "404"
						raise Telemetry::FlowNotFound, "#{Time.now} (HTTP 404): Requested object not found."
					when "429"
						raise Telemetry::RateLimited, "#{Time.now} (HTTP 429): Rate limited. Please reduce your update interval."
					when "500"
						raise Telemetry::ServerException, "#{Time.now} (HTTP 500): Data API server error."
					when "502"
						raise Telemetry::Unavailable, "#{Time.now} (HTTP 502): Data API server is down."
					when "503"
						raise Telemetry::Unavailable, "#{Time.now} (HTTP 503): Data API server is down."
					else
						raise Telemetry::UnknownError, "#{Time.now} ERROR UNK: #{response.body}."
					end
				end

			rescue Errno::ETIMEDOUT => e
				raise Telemetry::ConnectionError, "#{Time.now} ERROR #{e}"

			rescue Errno::ECONNREFUSED => e 
				raise Telemetry::ConnectionError, "#{Time.now} ERROR #{e}"

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
