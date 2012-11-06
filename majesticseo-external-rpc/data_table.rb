
=begin

  Version 0.9.3

  Copyright (c) 2011, Majestic-12 Ltd
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. Neither the name of the Majestic-12 Ltd nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

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

class DataTable

  attr_accessor :name;
  attr_reader :headers, :params, :rows;

  # This method returns a new instance of the DataTable class.
  # If the 'data' parameter is not provided, it will default to nil.
  def initialize()
    @name = '';
    @headers = Array.new;
    @params = Hash.new;
		@rows = Array.new;
  end

  # Set table's headers
  def set_table_headers(headers)
    @headers = split(headers);
  end

  # Set table's parameters
  def set_table_param(name, value)
    @params[name] = value;
  end

  # Set table's rows
  def set_table_row(row)
    rows_hash = Hash.new;
    elements = split(row);
    
    0.upto(elements.length-1) do |i|
      if(elements[i] == " ")
        elements[i] = "";
      end

      rows_hash[@headers[i]] = elements[i];
    end

    @rows.push(rows_hash);
  end

  # Splits the input from pipe separated form into an array.
  def split(text)
    test = text.split(/\|(?!\|)/);
    test.each_with_index do |value, index|
      if(value[-1,1] == "|")
        value << test[index+1];
        test.delete_at(index+1);
        redo;
      end
    end
  end

  # Returns a table's parameter for a given name
  def param_for_name(name)
    @params.fetch(name, nil);
  end

  # Returns the number of rows in the table
  def row_count
    @rows.length;
  end
  
end
