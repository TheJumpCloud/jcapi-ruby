# JCAPIv2::BulkJobRequestsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bulk_user_expires**](BulkJobRequestsApi.md#bulk_user_expires) | **POST** /bulk/user/expires | Bulk Expire Users
[**bulk_user_states_create**](BulkJobRequestsApi.md#bulk_user_states_create) | **POST** /bulk/userstates | Create Scheduled Userstate Job
[**bulk_user_states_delete**](BulkJobRequestsApi.md#bulk_user_states_delete) | **DELETE** /bulk/userstates/{id} | Delete Scheduled Userstate Job
[**bulk_user_states_get_next_scheduled**](BulkJobRequestsApi.md#bulk_user_states_get_next_scheduled) | **GET** /bulk/userstates/eventlist/next | Get the next scheduled state change for a list of users
[**bulk_user_states_list**](BulkJobRequestsApi.md#bulk_user_states_list) | **GET** /bulk/userstates | List Scheduled Userstate Change Jobs
[**bulk_user_unlocks**](BulkJobRequestsApi.md#bulk_user_unlocks) | **POST** /bulk/user/unlocks | Bulk Unlock Users
[**bulk_users_create**](BulkJobRequestsApi.md#bulk_users_create) | **POST** /bulk/users | Bulk Users Create
[**bulk_users_create_results**](BulkJobRequestsApi.md#bulk_users_create_results) | **GET** /bulk/users/{job_id}/results | List Bulk Users Results
[**bulk_users_update**](BulkJobRequestsApi.md#bulk_users_update) | **PATCH** /bulk/users | Bulk Users Update

# **bulk_user_expires**
> JobId bulk_user_expires(opts)

Bulk Expire Users

The endpoint allows you to start a bulk job to asynchronously expire users.

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
opts = { 
  body: [JCAPIv2::BulkUserExpire.new] # Array<BulkUserExpire> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Expire Users
  result = api_instance.bulk_user_expires(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_expires: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Array&lt;BulkUserExpire&gt;**](BulkUserExpire.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_user_states_create**
> Array&lt;ScheduledUserstateResult&gt; bulk_user_states_create(opts)

Create Scheduled Userstate Job

This endpoint allows you to create scheduled statechange jobs. #### Sample Request ``` curl -X POST \"https://console.jumpcloud.com/api/v2/bulk/userstates\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -d '{     \"user_ids\": [\"{User_ID_1}\", \"{User_ID_2}\", \"{User_ID_3}\"],     \"state\": \"SUSPENDED\",     \"start_date\": \"2000-01-01T00:00:00.000Z\"   }' ```

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
opts = { 
  body: JCAPIv2::BulkScheduledStatechangeCreate.new # BulkScheduledStatechangeCreate | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Scheduled Userstate Job
  result = api_instance.bulk_user_states_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**BulkScheduledStatechangeCreate**](BulkScheduledStatechangeCreate.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;ScheduledUserstateResult&gt;**](ScheduledUserstateResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_user_states_delete**
> bulk_user_states_delete(id, opts)

Delete Scheduled Userstate Job

This endpoint deletes a scheduled statechange job. #### Sample Request ``` curl -X DELETE \"https://console.jumpcloud.com/api/v2/bulk/userstates/{ScheduledJob_ID}\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' ```

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
id = 'id_example' # String | Unique identifier of the scheduled statechange job.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Scheduled Userstate Job
  api_instance.bulk_user_states_delete(id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the scheduled statechange job. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **bulk_user_states_get_next_scheduled**
> InlineResponse200 bulk_user_states_get_next_scheduled(users, opts)

Get the next scheduled state change for a list of users

This endpoint is used to lookup the next upcoming scheduled state change for each user in the given list. The users parameter is limited to 100 items per request. The results are also limited to 100 items. This endpoint returns a max of 1 event per state per user. For example, if a user has 3 ACTIVATED events scheduled it will return the next upcoming activation event. However, if a user also has a SUSPENDED event scheduled along with the ACTIVATED events it will return the next upcoming activation event _and_ the next upcoming suspension event.

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
users = ['users_example'] # Array<String> | A list of system user IDs, limited to 100 items.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get the next scheduled state change for a list of users
  result = api_instance.bulk_user_states_get_next_scheduled(users, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_get_next_scheduled: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **users** | [**Array&lt;String&gt;**](String.md)| A list of system user IDs, limited to 100 items. | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **bulk_user_states_list**
> Array&lt;ScheduledUserstateResult&gt; bulk_user_states_list(opts)

List Scheduled Userstate Change Jobs

The endpoint allows you to list scheduled statechange jobs. #### Sample Request ``` curl -X GET \"https://console.jumpcloud.com/api/v2/bulk/userstates\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' ```

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
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  userid: 'userid_example' # String | The systemuser id to filter by.
}

begin
  #List Scheduled Userstate Change Jobs
  result = api_instance.bulk_user_states_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **userid** | **String**| The systemuser id to filter by. | [optional] 

### Return type

[**Array&lt;ScheduledUserstateResult&gt;**](ScheduledUserstateResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **bulk_user_unlocks**
> JobId bulk_user_unlocks(opts)

Bulk Unlock Users

The endpoint allows you to start a bulk job to asynchronously unlock users.

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
opts = { 
  body: [JCAPIv2::BulkUserUnlock.new] # Array<BulkUserUnlock> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Unlock Users
  result = api_instance.bulk_user_unlocks(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_unlocks: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Array&lt;BulkUserUnlock&gt;**](BulkUserUnlock.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_users_create**
> JobId bulk_users_create(opts)

Bulk Users Create

The endpoint allows you to create a bulk job to asynchronously create users. See [Create a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_post) for the full list of attributes.  #### Default User State The `state` of each user in the request can be explicitly passed in or omitted. If `state` is omitted, then the user will get created using the value returned from the [Get an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organizations_get) endpoint. The default user state for bulk created users depends on the `creation-source` header. For `creation-source:jumpcloud:bulk` the default state is stored in `settings.newSystemUserStateDefaults.csvImport`. For other `creation-source` header values, the default state is stored in `settings.newSystemUserStateDefaults.applicationImport`  These default state values can be changed in the admin portal settings or by using the [Update an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organization_put) endpoint.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/bulk/users \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '[   {     \"email\":\"{email}\",     \"firstname\":\"{firstname}\",     \"lastname\":\"{firstname}\",     \"username\":\"{username}\",     \"attributes\":[       {         \"name\":\"EmployeeID\",         \"value\":\"0000\"       },       {         \"name\":\"Custom\",         \"value\":\"attribute\"       }     ]   } ]' ```

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
opts = { 
  body: [JCAPIv2::BulkUserCreate.new] # Array<BulkUserCreate> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
  creation_source: 'jumpcloud:bulk' # String | Defines the creation-source header for gapps, o365 and workdays requests. If the header isn't sent, the default value is `jumpcloud:bulk`, if you send the header with a malformed value you receive a 400 error. 
}

begin
  #Bulk Users Create
  result = api_instance.bulk_users_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Array&lt;BulkUserCreate&gt;**](BulkUserCreate.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **creation_source** | **String**| Defines the creation-source header for gapps, o365 and workdays requests. If the header isn&#x27;t sent, the default value is &#x60;jumpcloud:bulk&#x60;, if you send the header with a malformed value you receive a 400 error.  | [optional] [default to jumpcloud:bulk]

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **bulk_users_create_results**
> Array&lt;JobWorkresult&gt; bulk_users_create_results(job_id, opts)

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
job_id = 'job_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Bulk Users Results
  result = api_instance.bulk_users_create_results(job_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create_results: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;JobWorkresult&gt;**](JobWorkresult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **bulk_users_update**
> JobId bulk_users_update(opts)

Bulk Users Update

The endpoint allows you to create a bulk job to asynchronously update users. See [Update a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_put) for full list of attributes.  #### Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/bulk/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '[  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"department\":\"{UPDATED_DEPARTMENT}\",   \"attributes\":[    {\"name\":\"Custom\",\"value\":\"{ATTRIBUTE_VALUE}\"}   ]  },  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"costCenter\":\"{UPDATED_COST_CENTER}\",   \"phoneNumbers\":[    {\"type\":\"home\",\"number\":\"{HOME_PHONE_NUMBER}\"},    {\"type\":\"work\",\"number\":\"{WORK_PHONE_NUMBER}\"}   ]  } ] ```

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
opts = { 
  body: [JCAPIv2::BulkUserUpdate.new] # Array<BulkUserUpdate> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Users Update
  result = api_instance.bulk_users_update(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Array&lt;BulkUserUpdate&gt;**](BulkUserUpdate.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**JobId**](JobId.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



