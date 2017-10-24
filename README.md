Ruby-API-Connector
====================

Use the https://majestic.com connectors to access web data from one of the largest web indexes available. 
The Majestic® search engine is mainly used to instantly provide Flow Metrics® which evaluate the any page on the Internet in scores between 0 and 100.
 

For set up
---------------
Clone the repository in a directory. 

Install rubygems from https://rubygems.org/pages/download. Rubygems is a package manager used to manage and install gems.

Install libxml by running the following command in your terminal:

```gem install libxml-ruby```

Examples
-------------
There are a few examples of using the API-Connector in the following scripts:

* get_index_item_info.rb
  * The GetIndexItemInfo command provides data on the number of backlinks to any web page or site, linking domains and the main topics for that page or web site.
* get_backlink_data.rb
  * GetBacklinkData will return rows of data with information about all the pages linking to a given URL or domain.
* open_app_get_index_item_info.rb
  * A demonstration of implementing the GetIndexItemInfo command for an OpenApp.
  
The following code from get_index_item_info.rb demonstrates how the API-Connector can be used.

```
api_service = ApiService.new(api_key, endpoint);
response = api_service.execute_command('GetIndexItemInfo', items_hash);
```


Further notes  
------------------
The Ruby connector has been developed using Ruby 1.9.2.
**Please note that this connector requires the Ruby module libxml-ruby, which is problematic to set up on Windows.**
For further information see api documentation @ https://developer-support.majestic.com/
