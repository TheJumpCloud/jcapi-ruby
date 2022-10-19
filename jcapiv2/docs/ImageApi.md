# JCAPIv2::ImageApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applications_delete_logo**](ImageApi.md#applications_delete_logo) | **DELETE** /applications/{application_id}/logo | Delete application image

# **applications_delete_logo**
> applications_delete_logo(application_id, opts)

Delete application image

Deletes the specified image from an application

### Example
```ruby
# load the gem
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ImageApi.new
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete application image
  api_instance.applications_delete_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ImageApi->applications_delete_logo: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



