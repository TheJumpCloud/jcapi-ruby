# SwaggerClient::ActiveDirectoryApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activedirectories_delete**](ActiveDirectoryApi.md#activedirectories_delete) | **DELETE** /activedirectories/{id} | Delete an Active Directory
[**activedirectories_get**](ActiveDirectoryApi.md#activedirectories_get) | **GET** /activedirectories/{id} | Get an Active Directory
[**activedirectories_list**](ActiveDirectoryApi.md#activedirectories_list) | **GET** /activedirectories | List Active Directories
[**activedirectories_post**](ActiveDirectoryApi.md#activedirectories_post) | **POST** /activedirectories | Create a new Active Directory
[**graph_active_directory_associations_list**](ActiveDirectoryApi.md#graph_active_directory_associations_list) | **GET** /activedirectories/{activedirectory_id}/associations | List the associations of an Active Directory instance
[**graph_active_directory_associations_post**](ActiveDirectoryApi.md#graph_active_directory_associations_post) | **POST** /activedirectories/{activedirectory_id}/associations | Manage the associations of an Active Directory instance
[**graph_active_directory_traverse_user_group**](ActiveDirectoryApi.md#graph_active_directory_traverse_user_group) | **GET** /activedirectories/{activedirectory_id}/usergroups | List the User Groups associated with an Active Directory instance


# **activedirectories_delete**
> activedirectories_delete(id, content_type, accept)

Delete an Active Directory

This endpoint allows you to delete an Active Directory.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

id = "id_example" # String | ObjectID of this Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete an Active Directory
  api_instance.activedirectories_delete(id, content_type, accept)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of this Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **activedirectories_get**
> ActiveDirectoryOutput activedirectories_get(id, content_type, accept)

Get an Active Directory

This endpoint returns a specific Active Directory.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

id = "id_example" # String | ObjectID of this Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get an Active Directory
  result = api_instance.activedirectories_get(id, content_type, accept)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of this Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

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

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Active Directories
  result = api_instance.activedirectories_list(content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_list: #{e}"
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

[**Array&lt;ActiveDirectoryOutput&gt;**](ActiveDirectoryOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **activedirectories_post**
> ActiveDirectoryOutput activedirectories_post(content_type, accept, opts)

Create a new Active Directory

This endpoint allows you to create a new Active Directory.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::ActiveDirectoryInput.new # ActiveDirectoryInput | 
}

begin
  #Create a new Active Directory
  result = api_instance.activedirectories_post(content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**ActiveDirectoryInput**](ActiveDirectoryInput.md)|  | [optional] 

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

This endpoint returns the direct associations of this Active Directory instance.  A direct association can be a non-homogenous relationship between 2 different objects. For example Active Directory and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/activedirectories/{activedirectory_id}/associations?targets=user ```

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | 

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of an Active Directory instance
  result = api_instance.graph_active_directory_associations_list(activedirectory_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
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
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

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

This endpoint allows you to manage the _direct_ associations of an Active Directory instance.  A direct association can be a non-homogenous relationship between 2 different objects. For example Active Directory and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/activedirectories/{activedirectory_id}/associations ```

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of an Active Directory instance
  api_instance.graph_active_directory_associations_post(activedirectory_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
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

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_active_directory_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_active_directory_traverse_user_group(activedirectory_id, content_type, accept, opts)

List the User Groups associated with an Active Directory instance

This endpoint will return User Groups associated with an Active Directory instance. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Active Directory instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Active Directory instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/activedirectories/{activedirectory_id}/usersgroups ```

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::ActiveDirectoryApi.new

activedirectory_id = "activedirectory_id_example" # String | ObjectID of the Active Directory instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user_group(activedirectory_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activedirectory_id** | **String**| ObjectID of the Active Directory instance. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



