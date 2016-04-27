
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

# NOTE: The code below is specifically for the GetIndexItemInfo API command
#       For other API commands, the arguments required may differ.
#       Please refer to the Majestic Developer Wiki for more information
#       regarding other API commands and their arguments.


# add the majesticseo-external-rpc library to the search path
$: << File.expand_path(File.dirname(__FILE__));

require 'majesticseo-external-rpc/api_service'

endpoint = "https://api.majestic.com/api_command";

puts "\n***********************************************************" +
  "*****************";

puts "\nEndpoint: #{endpoint}";

if("https://api.majestic.com/api_command" == endpoint)
  puts "\nThis program is hard-wired to the Enterprise API.";

  puts "\nIf you do not have access to the Enterprise API, " +
    "change the endpoint to: \nhttps://developer.majestic.com/api_command.";
else
  puts "\nThis program is hard-wired to the Developer API " +
    "and hence the subset of data \nreturned will be substantially " +
    "smaller than that which will be returned from \neither the " +
    "Enterprise API or the Majestic website.";

  puts "\nTo make this program use the Enterprise API, change " +
    "the endpoint to: \nhttps://api.majestic.com/api_command.";
end

puts "\n***********************************************************" +
  "*****************";

puts "\n\nThis example program will return key information about \"index items\"." +
     "\n\nThe following must be provided in order to run this program: " +
	"\n1. OpenApp \"private key\"\n2. Access Token\n3. List of items to query" +
     "\n\nPlease enter a valid OpenApp \"private key\":\n";

private_key = gets.chomp;

puts "\nEnter your user access token:\n";

access_token = gets.chomp;

puts "\nPlease enter the list of items you wish to query seperated by " +
     "commas: \n(e.g. majestic.com, majestic12.co.uk)\n";

items_to_query = gets.chomp;
items = items_to_query.split(/, /);

# create a hash from the resulting array with the key being
# "item0 => first item to query, item1 => second item to query" etc
items_hash = Hash.new;
0.upto(items.length-1) do |i|
  items_hash["item" + i.to_s] = items[i];
end

# add the total number of items to the hash with the key being "items"
items_hash['items'] = items.length.to_s;
items_hash['datasource'] = 'fresh';

api_service = ApiService.new(private_key, endpoint);
response = api_service.execute_openapp_request('GetIndexItemInfo', items_hash, access_token);

# check the response code
if(response.is_ok)
  # print the results table
  results = response.table_for_name('Results');
  results.rows.each do |row|
    item = row['Item'];
    puts "\n<#{item}>\n";

    row.keys.sort.each do |key|
      unless(key.eql?('Item'))
        value = row[key];
        puts " #{key} ... #{value}\n";
      end
    end
  end

  if("https://developer.majestic.com/api_command" == endpoint)
    puts "\n\n***********************************************************" +
      "*****************";

    puts "\nEndpoint: #{endpoint}";

    puts"\nThis program is hard-wired to the Developer API " +
      "and hence the subset of data \nreturned will be substantially " +
      "smaller than that which will be returned from \neither the " +
      "Enterprise API or the Majestic website.";

    puts "\nTo make this program use the Enterprise API, change " +
      "the endpoint to: \nhttps://api.majestic.com/api_command.";

    puts "\n***********************************************************" +
      "*****************";
  end
else
  puts "\nERROR MESSAGE:";
  puts response.error_message;

  puts "\n\n***********************************************************" +
    "*****************";

  puts "\nDebugging Info:\n";
  puts "Endpoint:\t#{endpoint}\n";
  puts "OpenApp \"private key\":\t#{private_key}\n";
  puts "Access token:\t#{access_token}\n";

  if("https://api.majestic.com/api_command" == endpoint)
    puts "\n  Is this API Key valid for this Endpoint?";

    puts "\n  This program is hard-wired to the Enterprise API.";

    puts "\n  If you do not have access to the Enterprise API, " +
      "change the endpoint to: \n  https://devloper.majestic.com/api_command.";
  end

  puts "\n***********************************************************" +
    "*****************";
end