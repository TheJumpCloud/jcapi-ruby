# JCAPIv2::LogosApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**logos_get**](LogosApi.md#logos_get) | **GET** /logos/{id} | Get the logo associated with the specified id

# **logos_get**
> String logos_get(id)

Get the logo associated with the specified id

Return the logo image associated with the specified id

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::LogosApi.new
id = 'id_example' # String | 


begin
  #Get the logo associated with the specified id
  result = api_instance.logos_get(id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LogosApi->logos_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/gif, image/jpeg, image/png



