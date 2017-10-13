# SwaggerClient::LDAPServersApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_ldap_server_associations_list**](LDAPServersApi.md#graph_ldap_server_associations_list) | **GET** /ldapservers/{ldapserver_id}/associations | List the associations of a LDAP Server
[**graph_ldap_server_associations_post**](LDAPServersApi.md#graph_ldap_server_associations_post) | **POST** /ldapservers/{ldapserver_id}/associations | Manage the associations of a LDAP Server
[**graph_ldap_server_traverse_user**](LDAPServersApi.md#graph_ldap_server_traverse_user) | **GET** /ldapservers/{ldapserver_id}/users | List the Users associated with a LDAP Server
[**graph_ldap_server_traverse_user_group**](LDAPServersApi.md#graph_ldap_server_traverse_user_group) | **GET** /ldapservers/{ldapserver_id}/usergroups | List the User Groups associated with a LDAP Server
[**ldapservers_get**](LDAPServersApi.md#ldapservers_get) | **GET** /ldapservers/{id} | Get LDAP Server
[**ldapservers_list**](LDAPServersApi.md#ldapservers_list) | **GET** /ldapservers | List LDAP Servers


# **graph_ldap_server_associations_list**
> Array&lt;GraphConnection&gt; graph_ldap_server_associations_list(ldapserver_id, targets, content_type, accept, opts)

List the associations of a LDAP Server

This endpoint returns the _direct_ associations of this LDAP Server.  A direct association can be a non-homogenous relationship between 2 different objects. for example LDAP and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/ldapservers/{ldapserver_id}/associations?targets=user ```

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

api_instance = SwaggerClient::LDAPServersApi.new

ldapserver_id = "ldapserver_id_example" # String | ObjectID of the LDAP Server.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a LDAP Server
  result = api_instance.graph_ldap_server_associations_list(ldapserver_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **graph_ldap_server_associations_post**
> graph_ldap_server_associations_post(ldapserver_id, content_type, accept, opts)

Manage the associations of a LDAP Server

This endpoint allows you to manage the _direct_ associations of a LDAP Server.  A direct association can be a non-homogenous relationship between 2 different objects. for example LDAP and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/ldapservers/{ldapserver_id}/associations ```

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

api_instance = SwaggerClient::LDAPServersApi.new

ldapserver_id = "ldapserver_id_example" # String | ObjectID of the LDAP Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a LDAP Server
  api_instance.graph_ldap_server_associations_post(ldapserver_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **graph_ldap_server_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_ldap_server_traverse_user(ldapserver_id, content_type, accept, opts)

List the Users associated with a LDAP Server

This endpoint will return Users associated with an LDAP server instance. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/ldapservers/{ldapserver_id}/users ```

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

api_instance = SwaggerClient::LDAPServersApi.new

ldapserver_id = "ldapserver_id_example" # String | ObjectID of the LDAP Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user(ldapserver_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **graph_ldap_server_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_ldap_server_traverse_user_group(ldapserver_id, content_type, accept, opts)

List the User Groups associated with a LDAP Server

This endpoint will return User Groups associated with a LDAP server instance. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/ldapservers/{ldapserver_id}/usersgroups ```

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

api_instance = SwaggerClient::LDAPServersApi.new

ldapserver_id = "ldapserver_id_example" # String | ObjectID of the LDAP Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user_group(ldapserver_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **ldapservers_get**
> LdapServerOutput ldapservers_get(id, content_type, accept)

Get LDAP Server

This endpoint returns a specific LDAP server.

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

api_instance = SwaggerClient::LDAPServersApi.new

id = "id_example" # String | Unique identifier of the LDAP server.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get LDAP Server
  result = api_instance.ldapservers_get(id, content_type, accept)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the LDAP server. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**LdapServerOutput**](LdapServerOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **ldapservers_list**
> Array&lt;LdapServerOutput&gt; ldapservers_list(content_type, accept, opts)

List LDAP Servers

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

api_instance = SwaggerClient::LDAPServersApi.new

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
  #List LDAP Servers
  result = api_instance.ldapservers_list(content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_list: #{e}"
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

[**Array&lt;LdapServerOutput&gt;**](LdapServerOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



