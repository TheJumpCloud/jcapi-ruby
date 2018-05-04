# JCAPIv1::SearchApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search_systems_post**](SearchApi.md#search_systems_post) | **POST** /search/systems | Search Systems
[**search_systemusers_post**](SearchApi.md#search_systemusers_post) | **POST** /search/systemusers | Search System Users


# **search_systems_post**
> Systemuserslist search_systems_post(content_type, accept, opts)

Search Systems

Return Systems in multi-record format allowing for the passing of the 'filter' parameter. This WILL NOT allow you to add a new system.  To support advanced filtering you can use the `filter` parameter that can only be passed in the body of POST /api/search/* routes. The `filter` parameter must be passed as Content-Type application/json supports advanced filtering using the mongodb JSON query syntax.   The `filter` parameter is an object with a single property, either and or or with the value of the property being an array of query expressions.   This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the and or or are not included the default behavior is to match ALL query expressions.   #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/search/systemsusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ \"filter\" :     {         \"or\" :             [                 {\"hostname\" : { \"$regex\" : \"^www\" }},                 {\"hostname\" : {\"$regex\" : \"^db\"}}             ]     }, \"fields\" : \"os hostname displayName\" }' ```

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
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
}

begin
  #Search Systems
  result = api_instance.search_systems_post(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systems_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Search**](Search.md)|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **search_systemusers_post**
> Systemuserslist search_systemusers_post(content_type, accept, opts)

Search System Users

Return System Users in multi-record format allowing for the passing of the 'filter' parameter. This WILL NOT allow you to add a new system user.  To support advanced filtering you can use the `filter` parameter that can only be passed in the body of POST /api/search/* routes. The `filter` parameter must be passed as Content-Type application/json supports advanced filtering using the mongodb JSON query syntax.   The `filter` parameter is an object with a single property, either and or or with the value of the property being an array of query expressions.   This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the and or or are not included the default behavior is to match ALL query expressions.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/search/systemsusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ \"filter\" : [{\"email\" : { \"$regex\" : \"gmail.com$\"}}], \"fields\" : \"email username sudo\" }' ```

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
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
}

begin
  #Search System Users
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
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



