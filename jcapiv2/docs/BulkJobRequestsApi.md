# JCAPIv2::BulkJobRequestsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bulk_users_create**](BulkJobRequestsApi.md#bulk_users_create) | **POST** /bulk/users | Bulk Users Create
[**bulk_users_create_results**](BulkJobRequestsApi.md#bulk_users_create_results) | **GET** /bulk/users/{job_id}/results | List Bulk Users Results
[**bulk_users_update**](BulkJobRequestsApi.md#bulk_users_update) | **PATCH** /bulk/users | Bulk Users Update
[**jobs_get**](BulkJobRequestsApi.md#jobs_get) | **GET** /jobs/{id} | Get Job (incomplete)
[**jobs_results**](BulkJobRequestsApi.md#jobs_results) | **GET** /jobs/{id}/results | List Job Results


# **bulk_users_create**
> JobId bulk_users_create(content_type, accept, opts)

Bulk Users Create

The endpoint allows you to create a bulk job to asynchronously create users. See [Create a System User](https://docs.jumpcloud.com/1.0/systemusers/create-a-system-user) for full list of attributes.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/bulk/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '[  {   \"email\":\"{email}\",   \"firstname\":\"{firstname}\",   \"lastname\":\"{firstname}\",   \"username\":\"{username}\",   \"attributes\":[    {\"name\":\"EmployeeID\",\"value\":\"0000\"},    {\"name\":\"Custom\",\"value\":\"attribute\"}   ]  } ] ```

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

api_instance = JCAPIv2::BulkJobRequestsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: [JCAPIv2::BulkUserCreate.new], # Array<BulkUserCreate> | 
  x_org_id: "" # String | 
}

begin
  #Bulk Users Create
  result = api_instance.bulk_users_create(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Array&lt;BulkUserCreate&gt;**](BulkUserCreate.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_users_create_results**
> Array&lt;JobWorkresult&gt; bulk_users_create_results(job_id, content_type, accept, opts)

List Bulk Users Results

This endpoint will return the results of particular user import or update job request.  #### Sample Request ``` curl -X GET \\   https://console.jumpcloud.com/api/v2/bulk/users/{ImportJobID}/results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::BulkJobRequestsApi.new

job_id = "job_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List Bulk Users Results
  result = api_instance.bulk_users_create_results(job_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create_results: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;JobWorkresult&gt;**](JobWorkresult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_users_update**
> JobId bulk_users_update(content_type, accept, opts)

Bulk Users Update

The endpoint allows you to create a bulk job to asynchronously update users. See [Update a System User](https://docs.jumpcloud.com/1.0/systemusers/update-a-system-user) for full list of attributes.  #### Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/bulk/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '[  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"department\":\"{UPDATED_DEPARTMENT}\",   \"attributes\":[    {\"name\":\"Custom\",\"value\":\"{ATTRIBUTE_VALUE}\"}   ]  },  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"costCenter\":\"{UPDATED_COST_CENTER}\",   \"phoneNumbers\":[    {\"type\":\"home\",\"number\":\"{HOME_PHONE_NUMBER}\"},    {\"type\":\"work\",\"number\":\"{WORK_PHONE_NUMBER}\"}   ]  } ] ```

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

api_instance = JCAPIv2::BulkJobRequestsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: [JCAPIv2::BulkUserUpdate.new], # Array<BulkUserUpdate> | 
  x_org_id: "" # String | 
}

begin
  #Bulk Users Update
  result = api_instance.bulk_users_update(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Array&lt;BulkUserUpdate&gt;**](BulkUserUpdate.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jobs_get**
> JobDetails jobs_get(id, content_type, accept, opts)

Get Job (incomplete)

**This endpoint is not complete and should remain hidden as it's not functional yet.**

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

api_instance = JCAPIv2::BulkJobRequestsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Get Job (incomplete)
  result = api_instance.jobs_get(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->jobs_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**JobDetails**](JobDetails.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jobs_results**
> Array&lt;JobWorkresult&gt; jobs_results(id, content_type, accept, opts)

List Job Results

This endpoint will return the results of particular import job request.  #### Sample Request ``` curl -X GET \\   https://console.jumpcloud.com/api/v2/jobs/{ImportJobID}/results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::BulkJobRequestsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List Job Results
  result = api_instance.jobs_results(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->jobs_results: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;JobWorkresult&gt;**](JobWorkresult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



