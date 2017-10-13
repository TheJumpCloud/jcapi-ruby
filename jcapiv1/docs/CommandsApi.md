# SwaggerClient::CommandsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commands_delete**](CommandsApi.md#commands_delete) | **DELETE** /commands/{id} | Delete a Command
[**commands_get**](CommandsApi.md#commands_get) | **GET** /commands/{id} | List an individual Command
[**commands_list**](CommandsApi.md#commands_list) | **GET** /commands/ | List All Commands
[**commands_post**](CommandsApi.md#commands_post) | **POST** /commands/ | Create A Command
[**commands_put**](CommandsApi.md#commands_put) | **PUT** /commands/{id} | Update a Command


# **commands_delete**
> commands_delete(id, content_type, accept)

Delete a Command

Delete a specific command.

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

api_instance = SwaggerClient::CommandsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete a Command
  api_instance.commands_delete(id, content_type, accept)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CommandsApi->commands_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **commands_get**
> Command commands_get(id, content_type, accept, opts)

List an individual Command

Return a single command using the command ID.

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

api_instance = SwaggerClient::CommandsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List an individual Command
  result = api_instance.commands_get(id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CommandsApi->commands_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

### Return type

[**Command**](Command.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **commands_list**
> Commandslist commands_list(content_type, accept, opts)

List All Commands

Return all commands.

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

api_instance = SwaggerClient::CommandsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  skip: 0, # Integer | The offset into the records to return.
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List All Commands
  result = api_instance.commands_list(content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CommandsApi->commands_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

### Return type

[**Commandslist**](Commandslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **commands_post**
> Command commands_post(content_type, accept, opts)

Create A Command

Create a new command.

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

api_instance = SwaggerClient::CommandsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::Command.new # Command | 
}

begin
  #Create A Command
  result = api_instance.commands_post(content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CommandsApi->commands_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Command**](Command.md)|  | [optional] 

### Return type

[**Command**](Command.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **commands_put**
> Command commands_put(id, content_type, accept, opts)

Update a Command

Updates a command record from the command ID and returns the modified command record.

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

api_instance = SwaggerClient::CommandsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::Command.new # Command | 
}

begin
  #Update a Command
  result = api_instance.commands_put(id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling CommandsApi->commands_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Command**](Command.md)|  | [optional] 

### Return type

[**Command**](Command.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



