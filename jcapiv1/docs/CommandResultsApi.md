# JCAPIv1::CommandResultsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**command_results_delete**](CommandResultsApi.md#command_results_delete) | **DELETE** /commandresults/{id} | Delete a Command result
[**command_results_get**](CommandResultsApi.md#command_results_get) | **GET** /commandresults/{id} | List an individual Command result
[**command_results_list**](CommandResultsApi.md#command_results_list) | **GET** /commandresults | List all Command Results


# **command_results_delete**
> Commandresult command_results_delete(id, content_type, accept)

Delete a Command result

Deletes a specific command result.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete a Command result
  result = api_instance.command_results_delete(id, content_type, accept)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**Commandresult**](Commandresult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **command_results_get**
> Commandresult command_results_get(id, content_type, accept, opts)

List an individual Command result

Returns a specific command result.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List an individual Command result
  result = api_instance.command_results_get(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

### Return type

[**Commandresult**](Commandresult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **command_results_list**
> Commandresultslist command_results_list(content_type, accept, opts)

List all Command Results

Returns all command results.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all Command Results
  result = api_instance.command_results_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

### Return type

[**Commandresultslist**](Commandresultslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



