# JCAPIv2::CommandsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commands_cancel_queued_commands_by_workflow_instance_id**](CommandsApi.md#commands_cancel_queued_commands_by_workflow_instance_id) | **DELETE** /commandqueue/{workflow_instance_id} | Cancel all queued commands for an organization by workflow instance Id
[**commands_get_queued_commands_by_workflow**](CommandsApi.md#commands_get_queued_commands_by_workflow) | **GET** /queuedcommand/workflows | Fetch the queued Commands for an Organization
[**graph_command_associations_list**](CommandsApi.md#graph_command_associations_list) | **GET** /commands/{command_id}/associations | List the associations of a Command
[**graph_command_associations_post**](CommandsApi.md#graph_command_associations_post) | **POST** /commands/{command_id}/associations | Manage the associations of a Command
[**graph_command_traverse_system**](CommandsApi.md#graph_command_traverse_system) | **GET** /commands/{command_id}/systems | List the Systems bound to a Command
[**graph_command_traverse_system_group**](CommandsApi.md#graph_command_traverse_system_group) | **GET** /commands/{command_id}/systemgroups | List the System Groups bound to a Command

# **commands_cancel_queued_commands_by_workflow_instance_id**
> commands_cancel_queued_commands_by_workflow_instance_id(workflow_instance_id, opts)

Cancel all queued commands for an organization by workflow instance Id

This endpoint allows all queued commands for one workflow instance to be canceled.  #### Sample Request ```  curl -X DELETE https://console.jumpcloud.com/api/v2/commandqueue/{workflow_instance_id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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
workflow_instance_id = 'workflow_instance_id_example' # String | Workflow instance Id of the queued commands to cancel.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Cancel all queued commands for an organization by workflow instance Id
  api_instance.commands_cancel_queued_commands_by_workflow_instance_id(workflow_instance_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->commands_cancel_queued_commands_by_workflow_instance_id: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workflow_instance_id** | **String**| Workflow instance Id of the queued commands to cancel. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **commands_get_queued_commands_by_workflow**
> QueuedCommandList commands_get_queued_commands_by_workflow(opts)

Fetch the queued Commands for an Organization

This endpoint will return all queued Commands for an Organization.  Each element will contain the workflow ID, the command name, the launch type (e.g. manual, triggered, or scheduled), the target OS, the number of assigned devices, and the number of pending devices that have not yet ran the command.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/queuedcommand/workflows \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Fetch the queued Commands for an Organization
  result = api_instance.commands_get_queued_commands_by_workflow(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->commands_get_queued_commands_by_workflow: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **limit** | **Integer**|  | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**QueuedCommandList**](QueuedCommandList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **graph_command_associations_list**
> Array&lt;GraphConnection&gt; graph_command_associations_list(command_id, targets, opts)

List the associations of a Command

This endpoint will return the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations?targets=system_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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
command_id = 'command_id_example' # String | ObjectID of the Command.
targets = ['targets_example'] # Array<String> | Targets which a \"command\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Command
  result = api_instance.graph_command_associations_list(command_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;command\&quot; can be associated to. | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;GraphConnection&gt;**](GraphConnection.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **graph_command_associations_post**
> graph_command_associations_post(command_id, opts)

Manage the associations of a Command

This endpoint will allow you to manage the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request ```  curl -X POST https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system_group\",     \"id\": \"Group_ID\"   }' ```

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
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  body: JCAPIv2::GraphOperationCommand.new # GraphOperationCommand | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Command
  api_instance.graph_command_associations_post(command_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
 **body** | [**GraphOperationCommand**](GraphOperationCommand.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_command_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_command_traverse_system(command_id, opts)

List the Systems bound to a Command

This endpoint will return all Systems bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Command to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systems \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Command
  result = api_instance.graph_command_traverse_system(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **graph_command_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_command_traverse_system_group(command_id, opts)

List the System Groups bound to a Command

This endpoint will return all System Groups bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Command to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systemgroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Command
  result = api_instance.graph_command_traverse_system_group(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **command_id** | **String**| ObjectID of the Command. | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



