
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

require 'rubygems'
require 'libxml'
require 'open-uri'
require 'majesticseo-external-rpc/data_table'
include LibXML

class Response

  attr_reader :response_attributes, :params, :tables;

  # This method returns a new instance of the Response class.
  # If one of the parameters are not provided, it will default to nil.
  def initialize(xml_data = nil, code = nil, error_message = nil)
    @response_attributes = Hash.new;
    @params = Hash.new;
    @tables = Hash.new;

    if(!code.nil? && !error_message.nil?)
      @response_attributes['Code'] = code;
      @response_attributes['ErrorMessage'] = error_message;
      @response_attributes['FullError'] = error_message;
    end

    if(!xml_data.nil?)
      parser = XML::SaxParser.io(open(xml_data));
      parser.callbacks = CallBacks.new(self);
      parser.parse;
    end
  end

  # Indicates whether the response is ok
  def is_ok
   ["OK", "QueuedForProcessing"].include?(code);
  end

  # Returns the Response's message code - "OK" represents predicted state, all
  # else represents an error.
  def code
    @response_attributes['Code'];
  end

  # Returns the error message(if present) from the Response
  def error_message
    @response_attributes['ErrorMessage'];
  end

  # Returns the full error message(if present) from the Response
  def full_error
    @response_attributes['FullError'];
  end

  # Returns a specific parameter from the Response's parameters
  def param_for_name(name)
    if(@params.kind_of? Hash)
      @params[name];
    end
  end

  # Returns a specific DataTable object from the Response's data tables
  def table_for_name(name)
    if(! defined? name)
      return DataTable.new;
    end

    if(! @tables.has_key?(name))
      return DataTable.new;
    end

    @tables[name];
  end

end



# SAX parser class
class CallBacks
  include XML::SaxParser::Callbacks

  def initialize(response)
    @response = response;
    @data_table;
    @is_row = false;
    @row = "";
  end

  # parses the start element
  def on_start_element(element, attributes)
    case element

    when "Result"
      attributes.each do |attribute, value|
        @response.response_attributes[attribute] = value;
      end

    when "GlobalVars"
      attributes.each do |attribute, value|
        @response.params[attribute] = value;
      end

    when "DataTable"
      @data_table = DataTable.new;
      @data_table.name = attributes["Name"];
      @data_table.set_table_headers(attributes["Headers"]);

      attributes.each do |attribute, value|
        if("Name" != attribute && "Headers" != attribute)
          @data_table.set_table_param(attribute, value);
        end
      end

      @response.tables[@data_table.name] = @data_table;

    when "Row"
      @is_row = true;

    end
  end

  # parses the data within the elements
  def on_characters(chars)
    if(@is_row)
      @row << chars;
    end
  end

  # parses the end element
  def on_end_element(name)
    if(name == "Row")
      @data_table.set_table_row(@row);
      @is_row = false;
      @row = "";
    end
  end
end