# JCAPIv2::CommandsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_command_associations_list**](CommandsApi.md#graph_command_associations_list) | **GET** /commands/{command_id}/associations | List the associations of a Command
[**graph_command_associations_post**](CommandsApi.md#graph_command_associations_post) | **POST** /commands/{command_id}/associations | Manage the associations of a Command
[**graph_command_traverse_system**](CommandsApi.md#graph_command_traverse_system) | **GET** /commands/{command_id}/systems | List the Systems associated with a Command
[**graph_command_traverse_system_group**](CommandsApi.md#graph_command_traverse_system_group) | **GET** /commands/{command_id}/systemgroups | List the System Groups associated with a Command


# **graph_command_associations_list**
> Array&lt;GraphConnection&gt; graph_command_associations_list(command_id, targets, content_type, accept, opts)

List the associations of a Command

This endpoint will return the _direct_ associations of this Command.  A direct association can be a non-homogenous relationship between 2 different objects. for example Commands and User Groups.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/commands/{command_id}/associations?targets=user_group ```

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

api_instance = JCAPIv2::CommandsApi.new

command_id = "command_id_example" # String | ObjectID of the Command.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a Command
  result = api_instance.graph_command_associations_list(command_id, targets, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
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



# **graph_command_associations_post**
> graph_command_associations_post(command_id, content_type, accept, opts)

Manage the associations of a Command

This endpoint will allow you to manage the _direct_ associations of this Command.  A direct association can be a non-homogenous relationship between 2 different objects. for example Commands and User Groups.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/commands/{command_id}/associations

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

api_instance = JCAPIv2::CommandsApi.new

command_id = "command_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a Command
  api_instance.graph_command_associations_post(command_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
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



# **graph_command_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_command_traverse_system(command_id, content_type, accept, opts)

List the Systems associated with a Command

This endpoint will return Systems associated with a Command. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Command to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/commands/{command_id}/systems ```

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

api_instance = JCAPIv2::CommandsApi.new

command_id = "command_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Systems associated with a Command
  result = api_instance.graph_command_traverse_system(command_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
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



# **graph_command_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_command_traverse_system_group(command_id, content_type, accept, opts)

List the System Groups associated with a Command

This endpoint will return System Groups associated with a Command. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Command to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/commands/{command_id}/systemsgroups ```

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

api_instance = JCAPIv2::CommandsApi.new

command_id = "command_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the System Groups associated with a Command
  result = api_instance.graph_command_traverse_system_group(command_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
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



