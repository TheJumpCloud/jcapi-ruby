# JCAPIv1::SystemusersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**systemusers_delete**](SystemusersApi.md#systemusers_delete) | **DELETE** /systemusers/{id} | Delete a system user
[**systemusers_get**](SystemusersApi.md#systemusers_get) | **GET** /systemusers/{id} | List a system user
[**systemusers_list**](SystemusersApi.md#systemusers_list) | **GET** /systemusers | List all system users
[**systemusers_post**](SystemusersApi.md#systemusers_post) | **POST** /systemusers | Create a system user
[**systemusers_put**](SystemusersApi.md#systemusers_put) | **PUT** /systemusers/{id} | Update a system user
[**systemusers_systems_binding_list**](SystemusersApi.md#systemusers_systems_binding_list) | **GET** /systemusers/{id}/systems | List system user binding
[**systemusers_systems_binding_put**](SystemusersApi.md#systemusers_systems_binding_put) | **PUT** /systemusers/{id}/systems | Update a system user binding


# **systemusers_delete**
> Systemuserreturn systemusers_delete(id, content_type, accept)

Delete a system user

Delete a particular system user.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete a system user
  result = api_instance.systemusers_delete(id, content_type, accept)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_get**
> Systemuser systemusers_get(id, content_type, accept, opts)

List a system user

Get a particular System User.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

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
  #List a system user
  result = api_instance.systemusers_get(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_get: #{e}"
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

[**Systemuser**](Systemuser.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_list**
> Systemuserslist systemusers_list(content_type, accept, opts)

List all system users

Returns all systemusers.

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "" # String | 
}

begin
  #List all system users
  result = api_instance.systemusers_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**|  | [optional] [default to ]

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_post**
> Systemuserreturn systemusers_post(content_type, accept, opts)

Create a system user

Create a new system user.  ### Example  #### Create a system user  This example assumes there is already a Tag named \"admins\" in your JumpCloud account.  ``` curl \\   -d '{\"email\" : \"bob@myco.com\", \"username\" : \"bob\", \"tags\" : [\"admins\"]}' \\   -X 'POST' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/systemusers\"

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Systemuserputpost.new # Systemuserputpost | 
}

begin
  #Create a system user
  result = api_instance.systemusers_post(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Systemuserputpost**](Systemuserputpost.md)|  | [optional] 

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_put**
> Systemuserreturn systemusers_put(id, content_type, accept, opts)

Update a system user

Update a system user record and return the modified record.  ### Example  #### Add attributes to a System User  ``` curl \\  -X 'PUT' \\  -H 'Content-Type: application/json' \\  -H 'Accept: application/json' \\  -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\  -d '{ \"attributes\" : [ { \"name\" : \"myhappyattribute\", \"value\" : \"myhappyattributevalue\" }] }' \\  \"https://console.jumpcloud.com/api/systemusers/:id\" ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Systemuserputpost.new # Systemuserputpost | 
}

begin
  #Update a system user
  result = api_instance.systemusers_put(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Systemuserputpost**](Systemuserputpost.md)|  | [optional] 

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_systems_binding_list**
> Object systemusers_systems_binding_list(id, content_type, accept, opts)

List system user binding

List system bindings for a specific system user in a system and user binding format.  ### Examples  #### List system bindings for specific system user  ``` curl \\   -H 'Content-Type: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/systemusers/[SYSTEM_USER_ID_HERE]/systems\" ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

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
  #List system user binding
  result = api_instance.systemusers_systems_binding_list(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_systems_binding_list: #{e}"
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

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_systems_binding_put**
> Usersystembinding systemusers_systems_binding_put(id, content_type, accept, opts)

Update a system user binding

Adds or removes a system binding for a user.   This endpoint is only used for users still using JumpCloud Tags. If you are using JumpCloud Groups please refer to the documentation found [here](https://docs.jumpcloud.com/2.0/systems/manage-associations-of-a-system).  ### Example  #### Add (or remove) system to system user  ``` curl \\   -d '{ \"add\": [\"[SYSTEM_ID_TO_ADD_HERE]\"], \"remove\": [\"[SYSTEM_ID_TO_REMOVE_HERE]\"] }' \\   -X PUT \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/systemusers/[SYSTEM_USER_ID_HERE]/systems\" ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Usersystembindingsput.new # Usersystembindingsput | 
}

begin
  #Update a system user binding
  result = api_instance.systemusers_systems_binding_put(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_systems_binding_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Usersystembindingsput**](Usersystembindingsput.md)|  | [optional] 

### Return type

[**Usersystembinding**](Usersystembinding.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



