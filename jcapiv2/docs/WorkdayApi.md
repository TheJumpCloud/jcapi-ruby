# JCAPIv2::WorkdayApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**workdays_delete**](WorkdayApi.md#workdays_delete) | **DELETE** /workdays/{id} | Delete Workday
[**workdays_get**](WorkdayApi.md#workdays_get) | **GET** /workdays/{id} | Get Workday
[**workdays_list**](WorkdayApi.md#workdays_list) | **GET** /workdays | List Workdays
[**workdays_post**](WorkdayApi.md#workdays_post) | **POST** /workdays | Create new Workday
[**workdays_put**](WorkdayApi.md#workdays_put) | **PUT** /workdays/{id} | Update Workday
[**workdays_report**](WorkdayApi.md#workdays_report) | **GET** /workdays/{id}/report | Get Workday Report Results
[**workdays_settings**](WorkdayApi.md#workdays_settings) | **GET** /workdays/settings | Get Workday Settings


# **workdays_delete**
> workdays_delete(id, content_type, accept, opts)

Delete Workday

This endpoint allows you to delete a workday

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

api_instance = JCAPIv2::WorkdayApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::WorkdayRequest.new # WorkdayRequest | 
}

begin
  #Delete Workday
  api_instance.workdays_delete(id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**WorkdayRequest**](WorkdayRequest.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_get**
> WorkdayOutput workdays_get(id, content_type, accept)

Get Workday

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

api_instance = JCAPIv2::WorkdayApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get Workday
  result = api_instance.workdays_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_get: #{e}"
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



# **workdays_list**
> Array&lt;WorkdayOutput&gt; workdays_list(content_type, accept, opts)

List Workdays

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

api_instance = JCAPIv2::WorkdayApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Workdays
  result = api_instance.workdays_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| Supported operators are: eq, ne, gt, ge, lt, le, between, search | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

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

This endpoint allows you to create a new workday object

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

api_instance = JCAPIv2::WorkdayApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::Body.new # Body | 
}

begin
  #Create new Workday
  result = api_instance.workdays_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Body**](Body.md)|  | [optional] 

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

This endpoint allows you to update the name and report_url for a Workday Authentication Edit

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

api_instance = JCAPIv2::WorkdayApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::WorkdayInput.new # WorkdayInput | 
}

begin
  #Update Workday
  result = api_instance.workdays_put(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
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



# **workdays_report**
> WorkdayReportResult workdays_report(id, content_type, accept, opts)

Get Workday Report Results

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

api_instance = JCAPIv2::WorkdayApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get Workday Report Results
  result = api_instance.workdays_report(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_report: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| Supported operators are: eq, ne, gt, ge, lt, le, between, search | [optional] [default to ]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**WorkdayReportResult**](WorkdayReportResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **workdays_settings**
> InlineResponse200 workdays_settings(content_type, accept, opts)

Get Workday Settings

This endpoint allows you to obtain all settings needed for creating a workday instance, namely the URL to initiate an OAuth negotiation

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

api_instance = JCAPIv2::WorkdayApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  state: "state_example" # String | 
}

begin
  #Get Workday Settings
  result = api_instance.workdays_settings(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayApi->workdays_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **state** | **String**|  | [optional] 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



