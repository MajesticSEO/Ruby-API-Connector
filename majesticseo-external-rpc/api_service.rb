
=begin

	Copyright 2015, Majestic-12 Ltd trading as Majestic
	https://majestic.com

	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

		* Redistributions of source code must retain the above copyright
		  notice, this list of conditions and the following disclaimer.

		* Redistributions in binary form must reproduce the above copyright
		  notice, this list of conditions and the following disclaimer in the
		  documentation and/or other materials provided with the distribution.

		* Neither the name of Majestic-12 Ltd, its trademarks, nor any contributors
		  to the software may be used to endorse or promote products derived from
		  this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL Majestic-12 Ltd BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end

require 'cgi'
require 'majesticseo-external-rpc/response'
require 'net/http'
require 'net/https'
require 'uri'

class ApiService

	# This method returns a new instance of the ApiService class.
	# 'application_id' is the unique identifier for your application - for api requests, this is your "api key" ... 
	#	for OpenApp request, this is your "private key".
	# 'endpoint' is required and must point to the url you wish to target; ie: enterprise or developer.
	# E.g. api_service = ApiService.new('9A7R8Q4T8FA7GBYA4', 'https://developer.majestic.com/api_command');
	def initialize(application_id, endpoint)
		@application_id = application_id;
		@endpoint = endpoint;
	end

	# This method will execute the specified command as an api request.
	# 'name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
	# 'parameters' a hash containing the command parameters.
	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
	def execute_command(name, parameters, timeout = 5)
		query_parameters = parameters.merge({"app_api_key" => @application_id, "cmd" => name});
		self.execute_request(query_parameters, timeout);
	end

	# This will execute the specified command as an OpenApp request.
	# 'command_name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
	# 'parameters' a hash containing the command parameters.
	# 'access_token' the token provided by the user to access their resources.
	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
	def execute_openapp_request(command_name, parameters, access_token, timeout = 5)
		query_parameters = parameters.merge({"accesstoken" => access_token, "cmd" => command_name, "privatekey" => @application_id});
		self.execute_request(query_parameters, timeout);
	end

	# 'parameters' a hash containing the command parameters.
	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
	def execute_request(query_parameters, timeout)
		timeout(timeout) do
		  uri = URI.parse(@endpoint);		
      
      https = Net::HTTP.new(uri.host, uri.port);
      
      if(@endpoint =~ /^https:\/\//)
        https.use_ssl = true;
      end
      
      request = Net::HTTP::Post.new(uri.path);
      request.set_form_data(query_parameters);
      
      response = https.request(request);
      
      Response.new(response.body);
		end

		rescue Timeout::Error
			Response.new(nil, "ConnectionError", "Connection timed out");
	end

end
