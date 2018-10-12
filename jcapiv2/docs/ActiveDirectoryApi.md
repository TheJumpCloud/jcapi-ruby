# JCAPIv2::ActiveDirectoryApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activedirectories_delete**](ActiveDirectoryApi.md#activedirectories_delete) | **DELETE** /activedirectories/{id} | Delete an Active Directory
[**activedirectories_get**](ActiveDirectoryApi.md#activedirectories_get) | **GET** /activedirectories/{id} | Get an Active Directory
[**activedirectories_list**](ActiveDirectoryApi.md#activedirectories_list) | **GET** /activedirectories | List Active Directories
[**activedirectories_post**](ActiveDirectoryApi.md#activedirectories_post) | **POST** /activedirectories | Create a new Active Directory
[**graph_active_directory_associations_list**](ActiveDirectoryApi.md#graph_active_directory_associations_list) | **GET** /activedirectories/{activedirectory_id}/associations | List the associations of an Active Directory instance
[**graph_active_directory_associations_post**](ActiveDirectoryApi.md#graph_active_directory_associations_post) | **POST** /activedirectories/{activedirectory_id}/associations | Manage the associations of an Active Directory instance
[**graph_active_directory_traverse_user_group**](ActiveDirectoryApi.md#graph_active_directory_traverse_user_group) | **GET** /activedirectories/{activedirectory_id}/usergroups | List the User Groups bound to an Active Directory instance


# **activedirectories_delete**
> activedirectories_delete(id, content_type, accept, opts)

Delete an Active Directory

This endpoint allows you to delete an Active Directory Instance.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY'   ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

id = "id_example" # String | ObjectID of this Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Delete an Active Directory
  api_instance.activedirectories_delete(id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of this Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **activedirectories_get**
> ActiveDirectoryOutput activedirectories_get(id, content_type, accept, opts)

Get an Active Directory

This endpoint returns a specific Active Directory.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

id = "id_example" # String | ObjectID of this Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Get an Active Directory
  result = api_instance.activedirectories_get(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of this Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**ActiveDirectoryOutput**](ActiveDirectoryOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **activedirectories_list**
> Array&lt;ActiveDirectoryOutput&gt; activedirectories_list(content_type, accept, opts)

List Active Directories

This endpoint allows you to list all your Active Directory Instances.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/ \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: ["fields_example"], # Array<String> | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: "" # String | 
}

begin
  #List Active Directories
  result = api_instance.activedirectories_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;ActiveDirectoryOutput&gt;**](ActiveDirectoryOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **activedirectories_post**
> ActiveDirectoryOutput activedirectories_post(content_type, accept, opts)

Create a new Active Directory

This endpoint allows you to create a new Active Directory.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/activedirectories/ \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{         \"domain\": \"{DC=AD_domain_name;DC=com}\" } ' ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::ActiveDirectoryInput.new, # ActiveDirectoryInput | 
  x_org_id: "" # String | 
}

begin
  #Create a new Active Directory
  result = api_instance.activedirectories_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**ActiveDirectoryInput**](ActiveDirectoryInput.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**ActiveDirectoryOutput**](ActiveDirectoryOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_active_directory_associations_list**
> Array&lt;GraphConnection&gt; graph_active_directory_associations_list(activedirectory_id, targets, content_type, accept, opts)

List the associations of an Active Directory instance

This endpoint returns the direct associations of this Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/associations?targets=user \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | 

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the associations of an Active Directory instance
  result = api_instance.graph_active_directory_associations_list(activedirectory_id, targets, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activedirectory_id** | **String**|  | 
 **targets** | [**Array&lt;String&gt;**](String.md)|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;GraphConnection&gt;**](GraphConnection.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_active_directory_associations_post**
> graph_active_directory_associations_post(activedirectory_id, content_type, accept, opts)

Manage the associations of an Active Directory instance

This endpoint allows you to manage the _direct_ associations of an Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/activedirectories/{AD_Instance_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{         \"op\": \"add\",         \"type\": \"user\",         \"id\": \"{User_ID}\" } ' ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::GraphManagementReq.new, # GraphManagementReq | 
  x_org_id: "" # String | 
}

begin
  #Manage the associations of an Active Directory instance
  api_instance.graph_active_directory_associations_post(activedirectory_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activedirectory_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**GraphManagementReq**](GraphManagementReq.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_active_directory_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_active_directory_traverse_user_group(activedirectory_id, content_type, accept, opts)

List the User Groups bound to an Active Directory instance

This endpoint will return all Users Groups bound to an Active Directory instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Active Directory instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Active Directory instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | ObjectID of the Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the User Groups bound to an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user_group(activedirectory_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activedirectory_id** | **String**| ObjectID of the Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



