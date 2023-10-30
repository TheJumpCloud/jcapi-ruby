# JCAPIv2::GSuiteImportApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**gsuites_list_import_jumpcloud_users**](GSuiteImportApi.md#gsuites_list_import_jumpcloud_users) | **GET** /gsuites/{gsuite_id}/import/jumpcloudusers | Get a list of users in Jumpcloud format to import from a Google Workspace account.
[**gsuites_list_import_users**](GSuiteImportApi.md#gsuites_list_import_users) | **GET** /gsuites/{gsuite_id}/import/users | Get a list of users to import from a G Suite instance

# **gsuites_list_import_jumpcloud_users**
> InlineResponse2001 gsuites_list_import_jumpcloud_users(gsuite_id, opts)

Get a list of users in Jumpcloud format to import from a Google Workspace account.

Lists available G Suite users for import, translated to the Jumpcloud user schema.

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

api_instance = JCAPIv2::GSuiteImportApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users in Jumpcloud format to import from a Google Workspace account.
  result = api_instance.gsuites_list_import_jumpcloud_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteImportApi->gsuites_list_import_jumpcloud_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **max_results** | **Integer**| Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **order_by** | **String**| Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **page_token** | **String**| Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **query** | **String**| Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users. | [optional] 
 **sort_order** | **String**| Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 

### Return type

[**InlineResponse2001**](InlineResponse2001.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **gsuites_list_import_users**
> InlineResponse2002 gsuites_list_import_users(gsuite_id, opts)

Get a list of users to import from a G Suite instance

Lists G Suite users available for import.

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

api_instance = JCAPIv2::GSuiteImportApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users to import from a G Suite instance
  result = api_instance.gsuites_list_import_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteImportApi->gsuites_list_import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **max_results** | **Integer**| Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **order_by** | **String**| Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **page_token** | **String**| Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **query** | **String**| Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users. | [optional] 
 **sort_order** | **String**| Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 

### Return type

[**InlineResponse2002**](InlineResponse2002.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



