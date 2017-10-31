# JCAPIv1::RadiusServersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**radius_servers_list**](RadiusServersApi.md#radius_servers_list) | **GET** /radiusservers | List Radius Servers
[**radius_servers_put**](RadiusServersApi.md#radius_servers_put) | **PUT** /radiusservers:id | Update Radius Servers


# **radius_servers_list**
> Radiusserverslist radius_servers_list(content_type, accept, opts)

List Radius Servers

This endpoint allows you to get a list of all RADIUS servers in your organization.

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

api_instance = JCAPIv1::RadiusServersApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Radius Servers
  result = api_instance.radius_servers_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_list: #{e}"
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

[**Radiusserverslist**](Radiusserverslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **radius_servers_put**
> Radiusserverput radius_servers_put(content_type, accept, opts)

Update Radius Servers

This endpoint allows you to update RADIUS servers in your organization.

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

api_instance = JCAPIv1::RadiusServersApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Body.new # Body | 
}

begin
  #Update Radius Servers
  result = api_instance.radius_servers_put(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Body**](Body.md)|  | [optional] 

### Return type

[**Radiusserverput**](Radiusserverput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



