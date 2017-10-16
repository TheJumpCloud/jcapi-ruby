# JCAPIv2::UsersApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_user_associations_list**](UsersApi.md#graph_user_associations_list) | **GET** /users/{user_id}/associations | List the associations of a User
[**graph_user_associations_post**](UsersApi.md#graph_user_associations_post) | **POST** /users/{user_id}/associations | Manage the associations of a User
[**graph_user_member_of**](UsersApi.md#graph_user_member_of) | **GET** /users/{user_id}/memberof | List the parent Groups of a User
[**graph_user_traverse_application**](UsersApi.md#graph_user_traverse_application) | **GET** /users/{user_id}/applications | List the Applications associated with a User
[**graph_user_traverse_directory**](UsersApi.md#graph_user_traverse_directory) | **GET** /users/{user_id}/directories | List the Directories associated with a User
[**graph_user_traverse_g_suite**](UsersApi.md#graph_user_traverse_g_suite) | **GET** /users/{user_id}/gsuites | List the G Suite instances associated with a User
[**graph_user_traverse_ldap_server**](UsersApi.md#graph_user_traverse_ldap_server) | **GET** /users/{user_id}/ldapservers | List the LDAP servers associated with a User
[**graph_user_traverse_office365**](UsersApi.md#graph_user_traverse_office365) | **GET** /users/{user_id}/office365s | List the Office 365 instances associated with User
[**graph_user_traverse_radius_server**](UsersApi.md#graph_user_traverse_radius_server) | **GET** /users/{user_id}/radiusservers | List the RADIUS Servers associated with a User
[**graph_user_traverse_system**](UsersApi.md#graph_user_traverse_system) | **GET** /users/{user_id}/systems | List the Systems associated with a User


# **graph_user_associations_list**
> Array&lt;GraphConnection&gt; graph_user_associations_list(user_id, targets, content_type, accept, opts)

List the associations of a User

This endpoint returns the _direct_ associations of a User.  A direct association can be a non-homogenous relationship between 2 different objects. for example Users and Systems.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/associations?targets=user_group ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a User
  result = api_instance.graph_user_associations_list(user_id, targets, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_associations_post**
> graph_user_associations_post(user_id, content_type, accept, opts)

Manage the associations of a User

This endpoint allows you to manage the _direct_ associations of a User.  A direct association can be a non-homogenous relationship between 2 different objects. for example Users and Systems.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/associations ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a User
  api_instance.graph_user_associations_post(user_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_member_of**
> Array&lt;GraphObjectWithPaths&gt; graph_user_member_of(user_id, content_type, accept, opts)

List the parent Groups of a User

This endpoint returns all the User Groups a User is a member of.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/memberof ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the parent Groups of a User
  result = api_instance.graph_user_member_of(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_member_of: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_application**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_application(user_id, content_type, accept, opts)

List the Applications associated with a User

This endpoint will return Applications associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/applications ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Applications associated with a User
  result = api_instance.graph_user_traverse_application(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_application: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_directory**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_directory(user_id, content_type, accept, opts)

List the Directories associated with a User

This endpoint will return Directories associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directory from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/directories ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Directories associated with a User
  result = api_instance.graph_user_traverse_directory(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_directory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_g_suite**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_g_suite(user_id, content_type, accept, opts)

List the G Suite instances associated with a User

This endpoint will return G Suite instances associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/gsuites ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the G Suite instances associated with a User
  result = api_instance.graph_user_traverse_g_suite(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_g_suite: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_ldap_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_ldap_server(user_id, content_type, accept, opts)

List the LDAP servers associated with a User

This endpoint will return LDAP Servers associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/ldapservers ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the LDAP servers associated with a User
  result = api_instance.graph_user_traverse_ldap_server(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_ldap_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_office365**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_office365(user_id, content_type, accept, opts)

List the Office 365 instances associated with User

This endpoint will return Office 365 instances associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/office365s ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Office 365 instances associated with User
  result = api_instance.graph_user_traverse_office365(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_office365: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_radius_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_radius_server(user_id, content_type, accept, opts)

List the RADIUS Servers associated with a User

This endpoint will return RADIUS Servers associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/radiusservers ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the RADIUS Servers associated with a User
  result = api_instance.graph_user_traverse_radius_server(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_radius_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



# **graph_user_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_user_traverse_system(user_id, content_type, accept, opts)

List the Systems associated with a User

This endpoint will return Systems associated with a User. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/systems ```

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

api_instance = JCAPIv2::UsersApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Systems associated with a User
  result = api_instance.graph_user_traverse_system(user_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **String**| ObjectID of the User. | 
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



