# JCAPIv1::SearchApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search_systemusers_post**](SearchApi.md#search_systemusers_post) | **POST** /search/systemusers | List System Users


# **search_systemusers_post**
> Systemuserslist search_systemusers_post(content_type, accept, opts)

List System Users

Return System Users in multi-record format allowing for the passing of the 'filter' parameter. This WILL NOT allow you to add a new system.

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

api_instance = JCAPIv1::SearchApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Search.new, # Search | 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
}

begin
  #List System Users
  result = api_instance.search_systemusers_post(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systemusers_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Search**](Search.md)|  | [optional] 
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



