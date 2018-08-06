# JCAPIv2::GSuiteApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_g_suite_associations_list**](GSuiteApi.md#graph_g_suite_associations_list) | **GET** /gsuites/{gsuite_id}/associations | List the associations of a G Suite instance
[**graph_g_suite_associations_post**](GSuiteApi.md#graph_g_suite_associations_post) | **POST** /gsuites/{gsuite_id}/associations | Manage the associations of a G Suite instance
[**graph_g_suite_traverse_user**](GSuiteApi.md#graph_g_suite_traverse_user) | **GET** /gsuites/{gsuite_id}/users | List the Users bound to a G Suite instance
[**graph_g_suite_traverse_user_group**](GSuiteApi.md#graph_g_suite_traverse_user_group) | **GET** /gsuites/{gsuite_id}/usergroups | List the User Groups bound to a G Suite instance


# **graph_g_suite_associations_list**
> Array&lt;GraphConnection&gt; graph_g_suite_associations_list(gsuite_idtargets, content_type, accept, opts)

List the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogenous relationship between 2 different objects. for example G Suite and Users.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a G Suite instance
  result = api_instance.graph_g_suite_associations_list(gsuite_idtargets, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **targets** | [**Array&lt;String&gt;**](String.md)|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;GraphConnection&gt;**](GraphConnection.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_g_suite_associations_post**
> graph_g_suite_associations_post(gsuite_id, opts)

Manage the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogenous relationship between 2 different objects. for example G Suite and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\" }' ```

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

api_instance = JCAPIv2::GSuiteApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

opts = { 
  body: JCAPIv2::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a G Suite instance
  api_instance.graph_g_suite_associations_post(gsuite_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **body** | [**GraphManagementReq**](GraphManagementReq.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_g_suite_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_g_suite_traverse_user(gsuite_id, content_type, accept, opts)

List the Users bound to a G Suite instance

This endpoint will return all Users bound to a G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user(gsuite_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_g_suite_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_g_suite_traverse_user_group(gsuite_id, content_type, accept, opts)

List the User Groups bound to a G Suite instance

This endpoint will return all User Groups bound to an G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSuite_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user_group(gsuite_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



