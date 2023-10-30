# JCAPIv2::Office365ImportApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**office365s_list_import_users**](Office365ImportApi.md#office365s_list_import_users) | **GET** /office365s/{office365_id}/import/users | Get a list of users to import from an Office 365 instance

# **office365s_list_import_users**
> InlineResponse20011 office365s_list_import_users(office365_id, opts)

Get a list of users to import from an Office 365 instance

Lists Office 365 users available for import.

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

api_instance = JCAPIv2::Office365ImportApi.new
office365_id = 'office365_id_example' # String | 
opts = { 
  consistency_level: 'consistency_level_example', # String | Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#request-headers
  top: 56, # Integer | Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging.
  skip_token: 'skip_token_example', # String | Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging.
  filter: 'filter_example', # String | Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  search: 'search_example', # String | Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  orderby: 'orderby_example', # String | Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  count: true # BOOLEAN | Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
}

begin
  #Get a list of users to import from an Office 365 instance
  result = api_instance.office365s_list_import_users(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365ImportApi->office365s_list_import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **consistency_level** | **String**| Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#request-headers | [optional] 
 **top** | **Integer**| Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging. | [optional] 
 **skip_token** | **String**| Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging. | [optional] 
 **filter** | **String**| Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **search** | **String**| Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **orderby** | **String**| Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **count** | **BOOLEAN**| Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 

### Return type

[**InlineResponse20011**](InlineResponse20011.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



