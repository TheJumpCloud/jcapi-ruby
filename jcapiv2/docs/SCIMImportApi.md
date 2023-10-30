# JCAPIv2::SCIMImportApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**import_users**](SCIMImportApi.md#import_users) | **GET** /applications/{application_id}/import/users | Get a list of users to import from an Application IdM service provider

# **import_users**
> ImportUsersResponse import_users(application_id, opts)

Get a list of users to import from an Application IdM service provider

Get a list of users to import from an Application IdM service provider.

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

api_instance = JCAPIv2::SCIMImportApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  filter: 'filter_example', # String | Filter users by a search term
  query: 'query_example', # String | URL query to merge with the service provider request
  sort: 'sort_example', # String | Sort users by supported fields
  sort_order: 'asc', # String | 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get a list of users to import from an Application IdM service provider
  result = api_instance.import_users(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SCIMImportApi->import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
 **filter** | **String**| Filter users by a search term | [optional] 
 **query** | **String**| URL query to merge with the service provider request | [optional] 
 **sort** | **String**| Sort users by supported fields | [optional] 
 **sort_order** | **String**|  | [optional] [default to asc]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**ImportUsersResponse**](ImportUsersResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



