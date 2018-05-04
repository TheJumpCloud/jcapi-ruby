# JCAPIv2::WorkdayImportApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**workdays_authorize**](WorkdayImportApi.md#workdays_authorize) | **POST** /workdays/{workday_id}/auth | Authorize Workday
[**workdays_deauthorize**](WorkdayImportApi.md#workdays_deauthorize) | **DELETE** /workdays/{workday_id}/auth | Deauthorize Workday
[**workdays_delete**](WorkdayImportApi.md#workdays_delete) | **DELETE** /workdays/{id} | Delete Workday
[**workdays_get**](WorkdayImportApi.md#workdays_get) | **GET** /workdays/{id} | Get Workday
[**workdays_import**](WorkdayImportApi.md#workdays_import) | **POST** /workdays/{workday_id}/import/ | Workday Import
[**workdays_list**](WorkdayImportApi.md#workdays_list) | **GET** /workdays | List Workdays
[**workdays_post**](WorkdayImportApi.md#workdays_post) | **POST** /workdays | Create new Workday
[**workdays_put**](WorkdayImportApi.md#workdays_put) | **PUT** /workdays/{id} | Update Workday
[**workdays_settings**](WorkdayImportApi.md#workdays_settings) | **GET** /workdays/settings | Get Workday Settings
[**workdays_workers**](WorkdayImportApi.md#workdays_workers) | **GET** /workdays/{workday_id}/workers | List Workday Workers


# **workdays_authorize**
> workdays_authorize(workday_id, content_type, accept, opts)

Authorize Workday

Adds an authorization method to a workday instance

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

api_instance = JCAPIv2::WorkdayImportApi.new

workday_id = "workday_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::AuthInputObject.new # AuthInputObject | 
}

begin
  #Authorize Workday
  api_instance.workdays_authorize(workday_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_authorize: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workday_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**AuthInputObject**](AuthInputObject.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_deauthorize**
> workdays_deauthorize(workday_id, content_type, accept)

Deauthorize Workday

Removes any and all authorization methods from the workday instance

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

api_instance = JCAPIv2::WorkdayImportApi.new

workday_id = "workday_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Deauthorize Workday
  api_instance.workdays_deauthorize(workday_id, content_type, accept)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_deauthorize: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workday_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_delete**
> Object workdays_delete(id, content_type, accept)

Delete Workday

This endpoint allows you to delete an instance of Workday.

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

api_instance = JCAPIv2::WorkdayImportApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete Workday
  result = api_instance.workdays_delete(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_get**
> WorkdayOutput workdays_get(id, content_type, accept)

Get Workday

This endpoint will return  all the available information about an instance of Workday.

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

api_instance = JCAPIv2::WorkdayImportApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get Workday
  result = api_instance.workdays_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**WorkdayOutput**](WorkdayOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_import**
> JobId workdays_import(workday_id, content_type, accept, opts)

Workday Import

Still in development.

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

api_instance = JCAPIv2::WorkdayImportApi.new

workday_id = "workday_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: [JCAPIv2::WorkdayWorker.new] # Array<WorkdayWorker> | 
}

begin
  #Workday Import
  result = api_instance.workdays_import(workday_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_import: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workday_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Array&lt;WorkdayWorker&gt;**](WorkdayWorker.md)|  | [optional] 

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_list**
> Array&lt;WorkdayOutput&gt; workdays_list(content_type, accept, opts)

List Workdays

This endpoint will return  all the available information about all your instances of Workday.

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

api_instance = JCAPIv2::WorkdayImportApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: ["fields_example"], # Array<String> | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  limit: 10 # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Workdays
  result = api_instance.workdays_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;WorkdayOutput&gt;**](WorkdayOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_post**
> WorkdayOutput workdays_post(content_type, accept, opts)

Create new Workday

This endpoint allows you to create a new workday instance.  You must supply a username and password for Basic Authentication that is the same as your WorkDay Integrator System User.  Failure to provide these credentials  will result in the request being rejected.

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

api_instance = JCAPIv2::WorkdayImportApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::WorkdayInput.new # WorkdayInput | 
}

begin
  #Create new Workday
  result = api_instance.workdays_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**WorkdayInput**](WorkdayInput.md)|  | [optional] 

### Return type

[**WorkdayOutput**](WorkdayOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_put**
> WorkdayOutput workdays_put(id, content_type, accept, opts)

Update Workday

This endpoint allows you to update the name and Custom Report URL for a Workday Instance.

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

api_instance = JCAPIv2::WorkdayImportApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::WorkdayFields.new # WorkdayFields | 
}

begin
  #Update Workday
  result = api_instance.workdays_put(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**WorkdayFields**](WorkdayFields.md)|  | [optional] 

### Return type

[**WorkdayOutput**](WorkdayOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_settings**
> workdays_settings(content_type, accept, opts)

Get Workday Settings

This endpoint allows you to obtain all settings needed for creating a workday instance, specifically the URL to initiate Basic Authentication with WorkDay.

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

api_instance = JCAPIv2::WorkdayImportApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  state: "state_example" # String | 
}

begin
  #Get Workday Settings
  api_instance.workdays_settings(content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **state** | **String**|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_workers**
> Array&lt;WorkdayWorker&gt; workdays_workers(workday_id, content_type, accept, opts)

List Workday Workers

This endpoint will return all of the data available in your WorkDay Custom Report that has been associated with your WorkDay Instance.

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

api_instance = JCAPIv2::WorkdayImportApi.new

workday_id = "workday_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10 # Integer | The number of records to return at once.
}

begin
  #List Workday Workers
  result = api_instance.workdays_workers(workday_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_workers: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workday_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]

### Return type

[**Array&lt;WorkdayWorker&gt;**](WorkdayWorker.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



