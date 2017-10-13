# SwaggerClient::GraphApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_active_directory_associations_list**](GraphApi.md#graph_active_directory_associations_list) | **GET** /activedirectories/{activedirectory_id}/associations | List the associations of an Active Directory instance
[**graph_active_directory_associations_post**](GraphApi.md#graph_active_directory_associations_post) | **POST** /activedirectories/{activedirectory_id}/associations | Manage the associations of an Active Directory instance
[**graph_active_directory_traverse_user_group**](GraphApi.md#graph_active_directory_traverse_user_group) | **GET** /activedirectories/{activedirectory_id}/usergroups | List the User Groups associated with an Active Directory instance
[**graph_application_associations_list**](GraphApi.md#graph_application_associations_list) | **GET** /applications/{application_id}/associations | List the associations of an Application
[**graph_application_associations_post**](GraphApi.md#graph_application_associations_post) | **POST** /applications/{application_id}/associations | Manage the associations of an Application
[**graph_application_traverse_user**](GraphApi.md#graph_application_traverse_user) | **GET** /applications/{application_id}/users | List the Users associated with an Application
[**graph_application_traverse_user_group**](GraphApi.md#graph_application_traverse_user_group) | **GET** /applications/{application_id}/usergroups | List the User Groups associated with an Application
[**graph_command_associations_list**](GraphApi.md#graph_command_associations_list) | **GET** /commands/{command_id}/associations | List the associations of a Command
[**graph_command_associations_post**](GraphApi.md#graph_command_associations_post) | **POST** /commands/{command_id}/associations | Manage the associations of a Command
[**graph_command_traverse_system**](GraphApi.md#graph_command_traverse_system) | **GET** /commands/{command_id}/systems | List the Systems associated with a Command
[**graph_command_traverse_system_group**](GraphApi.md#graph_command_traverse_system_group) | **GET** /commands/{command_id}/systemgroups | List the System Groups associated with a Command
[**graph_g_suite_associations_list**](GraphApi.md#graph_g_suite_associations_list) | **GET** /gsuites/{gsuite_id}/associations | List the associations of a G Suite instance
[**graph_g_suite_associations_post**](GraphApi.md#graph_g_suite_associations_post) | **POST** /gsuites/{gsuite_id}/associations | Manage the associations of a G Suite instance
[**graph_g_suite_traverse_user**](GraphApi.md#graph_g_suite_traverse_user) | **GET** /gsuites/{gsuite_id}/users | List the Users associated with a G Suite instance
[**graph_g_suite_traverse_user_group**](GraphApi.md#graph_g_suite_traverse_user_group) | **GET** /gsuites/{gsuite_id}/usergroups | List the User Groups associated with a G Suite instance
[**graph_ldap_server_associations_list**](GraphApi.md#graph_ldap_server_associations_list) | **GET** /ldapservers/{ldapserver_id}/associations | List the associations of a LDAP Server
[**graph_ldap_server_associations_post**](GraphApi.md#graph_ldap_server_associations_post) | **POST** /ldapservers/{ldapserver_id}/associations | Manage the associations of a LDAP Server
[**graph_ldap_server_traverse_user**](GraphApi.md#graph_ldap_server_traverse_user) | **GET** /ldapservers/{ldapserver_id}/users | List the Users associated with a LDAP Server
[**graph_ldap_server_traverse_user_group**](GraphApi.md#graph_ldap_server_traverse_user_group) | **GET** /ldapservers/{ldapserver_id}/usergroups | List the User Groups associated with a LDAP Server
[**graph_office365_associations_list**](GraphApi.md#graph_office365_associations_list) | **GET** /office365s/{office365_id}/associations | List the associations of an Office 365 instance
[**graph_office365_associations_post**](GraphApi.md#graph_office365_associations_post) | **POST** /office365s/{office365_id}/associations | Manage the associations of an Office 365 instance
[**graph_office365_traverse_user**](GraphApi.md#graph_office365_traverse_user) | **GET** /office365s/{office365_id}/users | List the Users associated with an Office 365 instance
[**graph_office365_traverse_user_group**](GraphApi.md#graph_office365_traverse_user_group) | **GET** /office365s/{office365_id}/usergroups | List the User Groups associated with an Office 365 instance
[**graph_policy_associations_list**](GraphApi.md#graph_policy_associations_list) | **GET** /policies/{policy_id}/associations | List the associations of a Policy
[**graph_policy_associations_post**](GraphApi.md#graph_policy_associations_post) | **POST** /policies/{policy_id}/associations | Manage the associations of a Policy
[**graph_policy_traverse_system**](GraphApi.md#graph_policy_traverse_system) | **GET** /policies/{policy_id}/systems | List the Systems associated with a Policy
[**graph_policy_traverse_system_group**](GraphApi.md#graph_policy_traverse_system_group) | **GET** /policies/{policy_id}/systemgroups | List the System Groups associated with a Policy
[**graph_radius_server_associations_list**](GraphApi.md#graph_radius_server_associations_list) | **GET** /radiusservers/{radiusserver_id}/associations | List the associations of a Radius Server
[**graph_radius_server_associations_post**](GraphApi.md#graph_radius_server_associations_post) | **POST** /radiusservers/{radiusserver_id}/associations | Manage the associations of a Radius Server
[**graph_radius_server_traverse_user**](GraphApi.md#graph_radius_server_traverse_user) | **GET** /radiusservers/{radiusserver_id}/users | List the Users associated with a Radius Server
[**graph_radius_server_traverse_user_group**](GraphApi.md#graph_radius_server_traverse_user_group) | **GET** /radiusservers/{radiusserver_id}/usergroups | List the User Groups associated with a Radius Server
[**graph_system_associations_list**](GraphApi.md#graph_system_associations_list) | **GET** /systems/{system_id}/associations | List the associations of a System
[**graph_system_associations_post**](GraphApi.md#graph_system_associations_post) | **POST** /systems/{system_id}/associations | Manage associations of a System
[**graph_system_group_associations_list**](GraphApi.md#graph_system_group_associations_list) | **GET** /systemgroups/{group_id}/associations | List the associations of a System Group
[**graph_system_group_associations_post**](GraphApi.md#graph_system_group_associations_post) | **POST** /systemgroups/{group_id}/associations | Manage the associations of a System Group
[**graph_system_group_member_of**](GraphApi.md#graph_system_group_member_of) | **GET** /systemgroups/{group_id}/memberof | List the System Group&#39;s parents
[**graph_system_group_members_list**](GraphApi.md#graph_system_group_members_list) | **GET** /systemgroups/{group_id}/members | List the members of a System Group
[**graph_system_group_members_post**](GraphApi.md#graph_system_group_members_post) | **POST** /systemgroups/{group_id}/members | Manage the members of a System Group
[**graph_system_group_membership**](GraphApi.md#graph_system_group_membership) | **GET** /systemgroups/{group_id}/membership | List the System Group&#39;s membership
[**graph_system_group_traverse_policy**](GraphApi.md#graph_system_group_traverse_policy) | **GET** /systemgroups/{group_id}/policies | List the Policies associated with a System Group
[**graph_system_group_traverse_user**](GraphApi.md#graph_system_group_traverse_user) | **GET** /systemgroups/{group_id}/users | List the Users associated with a System Group
[**graph_system_group_traverse_user_group**](GraphApi.md#graph_system_group_traverse_user_group) | **GET** /systemgroups/{group_id}/usergroups | List the User Groups associated with a System Group
[**graph_system_member_of**](GraphApi.md#graph_system_member_of) | **GET** /systems/{system_id}/memberof | List the parent Groups of a System
[**graph_system_traverse_policy**](GraphApi.md#graph_system_traverse_policy) | **GET** /systems/{system_id}/policies | List the Policies associated with a System
[**graph_system_traverse_user**](GraphApi.md#graph_system_traverse_user) | **GET** /systems/{system_id}/users | List the Users associated with a System
[**graph_user_associations_list**](GraphApi.md#graph_user_associations_list) | **GET** /users/{user_id}/associations | List the associations of a User
[**graph_user_associations_post**](GraphApi.md#graph_user_associations_post) | **POST** /users/{user_id}/associations | Manage the associations of a User
[**graph_user_group_associations_list**](GraphApi.md#graph_user_group_associations_list) | **GET** /usergroups/{group_id}/associations | List the associations of a User Group.
[**graph_user_group_associations_post**](GraphApi.md#graph_user_group_associations_post) | **POST** /usergroups/{group_id}/associations | Manage the associations of a User Group
[**graph_user_group_member_of**](GraphApi.md#graph_user_group_member_of) | **GET** /usergroups/{group_id}/memberof | List the User Group&#39;s parents
[**graph_user_group_members_list**](GraphApi.md#graph_user_group_members_list) | **GET** /usergroups/{group_id}/members | List the members of a User Group
[**graph_user_group_members_post**](GraphApi.md#graph_user_group_members_post) | **POST** /usergroups/{group_id}/members | Manage the members of a User Group
[**graph_user_group_membership**](GraphApi.md#graph_user_group_membership) | **GET** /usergroups/{group_id}/membership | List the User Group&#39;s membership
[**graph_user_group_traverse_active_directory**](GraphApi.md#graph_user_group_traverse_active_directory) | **GET** /usergroups/{group_id}/activedirectories | List the Active Directories associated with a User Group
[**graph_user_group_traverse_application**](GraphApi.md#graph_user_group_traverse_application) | **GET** /usergroups/{group_id}/applications | List the Applications associated with a User Group
[**graph_user_group_traverse_directory**](GraphApi.md#graph_user_group_traverse_directory) | **GET** /usergroups/{group_id}/directories | List the Directories associated with a User Group
[**graph_user_group_traverse_g_suite**](GraphApi.md#graph_user_group_traverse_g_suite) | **GET** /usergroups/{group_id}/gsuites | List the G Suite instances associated with a User Group
[**graph_user_group_traverse_ldap_server**](GraphApi.md#graph_user_group_traverse_ldap_server) | **GET** /usergroups/{group_id}/ldapservers | List the LDAP Servers associated with a User Group
[**graph_user_group_traverse_office365**](GraphApi.md#graph_user_group_traverse_office365) | **GET** /usergroups/{group_id}/office365s | List the Office 365 instances associated with a User Group
[**graph_user_group_traverse_radius_server**](GraphApi.md#graph_user_group_traverse_radius_server) | **GET** /usergroups/{group_id}/radiusservers | List the RADIUS Servers associated with a User Group
[**graph_user_group_traverse_system**](GraphApi.md#graph_user_group_traverse_system) | **GET** /usergroups/{group_id}/systems | List the Systems associated with a User Group
[**graph_user_group_traverse_system_group**](GraphApi.md#graph_user_group_traverse_system_group) | **GET** /usergroups/{group_id}/systemgroups | List the System Groups associated with User Groups
[**graph_user_member_of**](GraphApi.md#graph_user_member_of) | **GET** /users/{user_id}/memberof | List the parent Groups of a User
[**graph_user_traverse_application**](GraphApi.md#graph_user_traverse_application) | **GET** /users/{user_id}/applications | List the Applications associated with a User
[**graph_user_traverse_directory**](GraphApi.md#graph_user_traverse_directory) | **GET** /users/{user_id}/directories | List the Directories associated with a User
[**graph_user_traverse_g_suite**](GraphApi.md#graph_user_traverse_g_suite) | **GET** /users/{user_id}/gsuites | List the G Suite instances associated with a User
[**graph_user_traverse_ldap_server**](GraphApi.md#graph_user_traverse_ldap_server) | **GET** /users/{user_id}/ldapservers | List the LDAP servers associated with a User
[**graph_user_traverse_office365**](GraphApi.md#graph_user_traverse_office365) | **GET** /users/{user_id}/office365s | List the Office 365 instances associated with User
[**graph_user_traverse_radius_server**](GraphApi.md#graph_user_traverse_radius_server) | **GET** /users/{user_id}/radiusservers | List the RADIUS Servers associated with a User
[**graph_user_traverse_system**](GraphApi.md#graph_user_traverse_system) | **GET** /users/{user_id}/systems | List the Systems associated with a User


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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_active_directory_associations_list: #{e}"
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_active_directory_associations_post: #{e}"
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_active_directory_traverse_user_group: #{e}"
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



# **graph_application_associations_list**
> Array&lt;GraphConnection&gt; graph_application_associations_list(application_id, targets, content_type, accept, opts)

List the associations of an Application

This endpoint will return the _direct_ associations of an Application. A direct association can be a non-homogenous relationship between 2 different objects. for example Applications and User Groups.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/applications/{application_id}/associations?targets=user_group ```

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

api_instance = SwaggerClient::GraphApi.new

application_id = "application_id_example" # String | ObjectID of the Application.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of an Application
  result = api_instance.graph_application_associations_list(application_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_application_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **graph_application_associations_post**
> graph_application_associations_post(application_id, content_type, accept, opts)

Manage the associations of an Application

This endpoint allows you to manage the _direct_ associations of an Application. A direct association can be a non-homogenous relationship between 2 different objects. for example Application and User Groups.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/applications/{application_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

application_id = "application_id_example" # String | ObjectID of the Application.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of an Application
  api_instance.graph_application_associations_post(application_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_application_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **graph_application_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_application_traverse_user(application_id, content_type, accept, opts)

List the Users associated with an Application

This endpoint will return Users associated with an Application. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Application to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/applications/{application_id}/users ```

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

api_instance = SwaggerClient::GraphApi.new

application_id = "application_id_example" # String | ObjectID of the Application.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with an Application
  result = api_instance.graph_application_traverse_user(application_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_application_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **graph_application_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_application_traverse_user_group(application_id, content_type, accept, opts)

List the User Groups associated with an Application

This endpoint will return User Groups associated with an Application. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates  each path from this Application to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/applications/{application_id}/usergroups ```

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

api_instance = SwaggerClient::GraphApi.new

application_id = "application_id_example" # String | ObjectID of the Application.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with an Application
  result = api_instance.graph_application_traverse_user_group(application_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_application_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **graph_command_associations_list**
> Array&lt;GraphConnection&gt; graph_command_associations_list(command_id, targets, content_type, accept, opts)

List the associations of a Command

This endpoint will return the _direct_ associations of this Command.  A direct association can be a non-homogenous relationship between 2 different objects. for example Commands and User Groups.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/commands/{command_id}/associations?targets=user_group ```

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

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_command_associations_list: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

command_id = "command_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a Command
  api_instance.graph_command_associations_post(command_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_command_associations_post: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_command_traverse_system: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_command_traverse_system_group: #{e}"
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



# **graph_g_suite_associations_list**
> Array&lt;GraphConnection&gt; graph_g_suite_associations_list(gsuite_idtargets, content_type, accept, opts)

List the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogenous relationship between 2 different objects. for example G Suite and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a G Suite instance
  result = api_instance.graph_g_suite_associations_list(gsuite_idtargets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
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



# **graph_g_suite_associations_post**
> graph_g_suite_associations_post(gsuite_id, opts)

Manage the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogenous relationship between 2 different objects. for example G Suite and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a G Suite instance
  api_instance.graph_g_suite_associations_post(gsuite_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_associations_post: #{e}"
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

List the Users associated with a G Suite instance

This endpoint will return Users associated with a G Suite instance. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this G Suite instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/users ```

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

api_instance = SwaggerClient::GraphApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with a G Suite instance
  result = api_instance.graph_g_suite_traverse_user(gsuite_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
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



# **graph_g_suite_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_g_suite_traverse_user_group(gsuite_id, content_type, accept, opts)

List the User Groups associated with a G Suite instance

This endpoint will return User Groups associated with a G Suite instance. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this G Suite instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/usersgroups ```

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

api_instance = SwaggerClient::GraphApi.new

gsuite_id = "gsuite_id_example" # String | ObjectID of the G Suite instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with a G Suite instance
  result = api_instance.graph_g_suite_traverse_user_group(gsuite_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_ldap_server_associations_list: #{e}"
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_ldap_server_associations_post: #{e}"
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_ldap_server_traverse_user: #{e}"
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

api_instance = SwaggerClient::GraphApi.new

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
  puts "Exception when calling GraphApi->graph_ldap_server_traverse_user_group: #{e}"
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



# **graph_office365_associations_list**
> Array&lt;GraphConnection&gt; graph_office365_associations_list(office365_id, targets, content_type, accept, opts)

List the associations of an Office 365 instance

This endpoint returns _direct_ associations of an Office 365 instance.   A direct association can be a non-homogenous relationship between 2 different objects. for example Office 365 and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/office365s/{office365_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

office365_id = "office365_id_example" # String | ObjectID of the Office 365 instance.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of an Office 365 instance
  result = api_instance.graph_office365_associations_list(office365_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
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



# **graph_office365_associations_post**
> graph_office365_associations_post(office365_id, content_type, accept, opts)

Manage the associations of an Office 365 instance

This endpoint allows you to manage the _direct_ associations of a Office 365 instance.  A direct association can be a non-homogenous relationship between 2 different objects. for example Office 365 and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/office365s/{office365_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

office365_id = "office365_id_example" # String | ObjectID of the Office 365 instance.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of an Office 365 instance
  api_instance.graph_office365_associations_post(office365_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
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



# **graph_office365_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_office365_traverse_user(office365_id, content_type, accept, opts)

List the Users associated with an Office 365 instance

This endpoint will return Users associated with an Office 365 instance. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/office365s/{office365_id}/users ```

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

api_instance = SwaggerClient::GraphApi.new

office365_id = "office365_id_example" # String | ObjectID of the Office 365 suite.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with an Office 365 instance
  result = api_instance.graph_office365_traverse_user(office365_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 suite. | 
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



# **graph_office365_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_office365_traverse_user_group(office365_id, content_type, accept, opts)

List the User Groups associated with an Office 365 instance

This endpoint will return User Groups associated with an Office 365 instance. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/office365s/{office365_id}/usergroups ```

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

api_instance = SwaggerClient::GraphApi.new

office365_id = "office365_id_example" # String | ObjectID of the Office 365 suite.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with an Office 365 instance
  result = api_instance.graph_office365_traverse_user_group(office365_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 suite. | 
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



# **graph_policy_associations_list**
> Array&lt;GraphConnection&gt; graph_policy_associations_list(policy_id, targets, content_type, accept, opts)

List the associations of a Policy

This endpoint returns the _direct_ associations of a Policy.  A direct association can be a non-homogenous relationship between 2 different objects. for example Policies and Systems.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/policies/{policy_id}/associations?targets=system ```

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

api_instance = SwaggerClient::GraphApi.new

policy_id = "policy_id_example" # String | ObjectID of the Policy.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a Policy
  result = api_instance.graph_policy_associations_list(policy_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy_id** | **String**| ObjectID of the Policy. | 
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



# **graph_policy_associations_post**
> graph_policy_associations_post(policy_id, content_type, accept, opts)

Manage the associations of a Policy

This endpoint allows you to manage the _direct_ associations of a Policy.  A direct association can be a non-homogenous relationship between 2 different objects. for example Policies and Systems.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/policies/{policy_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

policy_id = "policy_id_example" # String | ObjectID of the Policy.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a Policy
  api_instance.graph_policy_associations_post(policy_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy_id** | **String**| ObjectID of the Policy. | 
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



# **graph_policy_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_policy_traverse_system(policy_id, content_type, accept, opts)

List the Systems associated with a Policy

This endpoint will return Systems associated with a Policy. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Policy to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Policy.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/policies/{policy_id}/systems ```

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

api_instance = SwaggerClient::GraphApi.new

policy_id = "policy_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Systems associated with a Policy
  result = api_instance.graph_policy_traverse_system(policy_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy_id** | **String**| ObjectID of the Command. | 
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



# **graph_policy_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_policy_traverse_system_group(policy_id, content_type, accept, opts)

List the System Groups associated with a Policy

This endpoint will return System Groups associated with a Policy. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this Policy to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Policy.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/policies/{policy_id}/systemsgroups ```

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

api_instance = SwaggerClient::GraphApi.new

policy_id = "policy_id_example" # String | ObjectID of the Command.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the System Groups associated with a Policy
  result = api_instance.graph_policy_traverse_system_group(policy_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy_id** | **String**| ObjectID of the Command. | 
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



# **graph_radius_server_associations_list**
> Array&lt;GraphConnection&gt; graph_radius_server_associations_list(radiusserver_id, targets, content_type, accept, opts)

List the associations of a Radius Server

This endpoint returns the _direct_ associations of a Radius Server.  A direct association can be a non-homogenous relationship between 2 different objects. for example Radius Servers and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/radiusservers/{radiusserver_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

radiusserver_id = "radiusserver_id_example" # String | ObjectID of the Radius Server.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a Radius Server
  result = api_instance.graph_radius_server_associations_list(radiusserver_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



# **graph_radius_server_associations_post**
> graph_radius_server_associations_post(radiusserver_id, content_type, accept, opts)

Manage the associations of a Radius Server

This endpoint allows you to manage the _direct_ associations of a Radius Server.  A direct association can be a non-homogenous relationship between 2 different objects. for example Radius Servers and Users.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/radiusservers/{radiusserver_id}/associations

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

api_instance = SwaggerClient::GraphApi.new

radiusserver_id = "radiusserver_id_example" # String | ObjectID of the Radius Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a Radius Server
  api_instance.graph_radius_server_associations_post(radiusserver_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



# **graph_radius_server_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_radius_server_traverse_user(radiusserver_id, content_type, accept, opts)

List the Users associated with a Radius Server

This endpoint will return Users associated with a RADIUS server instance. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/radiusservers/{radiusserver_id}/users

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

api_instance = SwaggerClient::GraphApi.new

radiusserver_id = "radiusserver_id_example" # String | ObjectID of the Radius Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with a Radius Server
  result = api_instance.graph_radius_server_traverse_user(radiusserver_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



# **graph_radius_server_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_radius_server_traverse_user_group(radiusserver_id, content_type, accept, opts)

List the User Groups associated with a Radius Server

This endpoint will return User Groups associated with a RADIUS server instance. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/radiusservers/{radiusserver_id}/usergroups

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

api_instance = SwaggerClient::GraphApi.new

radiusserver_id = "radiusserver_id_example" # String | ObjectID of the Radius Server.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with a Radius Server
  result = api_instance.graph_radius_server_traverse_user_group(radiusserver_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



# **graph_system_associations_list**
> Array&lt;GraphConnection&gt; graph_system_associations_list(system_id, targets, content_type, accept, opts)

List the associations of a System

This endpoint returns the _direct_ associations of a System.  A direct association can be a non-homogenous relationship between 2 different objects. for example Systems and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/systems/{system_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

system_id = "system_id_example" # String | ObjectID of the System.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a System
  result = api_instance.graph_system_associations_list(system_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **system_id** | **String**| ObjectID of the System. | 
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



# **graph_system_associations_post**
> graph_system_associations_post(system_id, content_type, accept, opts)

Manage associations of a System

This endpoint allows you to manage the _direct_ associations of a System.  A direct association can be a non-homogenous relationship between 2 different objects. for example Systems and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/systems/{system_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

system_id = "system_id_example" # String | ObjectID of the System.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage associations of a System
  api_instance.graph_system_associations_post(system_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **system_id** | **String**| ObjectID of the System. | 
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



# **graph_system_group_associations_list**
> Array&lt;GraphConnection&gt; graph_system_group_associations_list(group_id, targets, content_type, accept, opts)

List the associations of a System Group

This endpoint returns the _direct_ associations of a System Group.  A direct association can be a non-homogenous relationship between 2 different objects. for example System Groups and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a System Group
  result = api_instance.graph_system_group_associations_list(group_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_associations_post**
> graph_system_group_associations_post(group_id, content_type, accept, opts)

Manage the associations of a System Group

This endpoint allows you to manage the _direct_ associations of a System Group.  A direct association can be a non-homogenous relationship between 2 different objects. for example System Groups and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::SystemGroupGraphManagementReq.new # SystemGroupGraphManagementReq | 
}

begin
  #Manage the associations of a System Group
  api_instance.graph_system_group_associations_post(group_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupGraphManagementReq**](SystemGroupGraphManagementReq.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_system_group_member_of**
> Array&lt;GraphObjectWithPaths&gt; graph_system_group_member_of(group_id, content_type, accept, opts)

List the System Group's parents

This endpoint returns all System Groups a System Group is a member of.  This endpoint is not yet public as we haven't completed the code yet.

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the System Group's parents
  result = api_instance.graph_system_group_member_of(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_member_of: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_members_list**
> Array&lt;GraphConnection&gt; graph_system_group_members_list(group_id, content_type, accept, opts)

List the members of a System Group

This endpoint returns the system members of a System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/members ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the members of a System Group
  result = api_instance.graph_system_group_members_list(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_members_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_members_post**
> graph_system_group_members_post(group_id, content_type, accept, opts)

Manage the members of a System Group

This endpoint allows you to manage the system members of a System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/members ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::SystemGroupMembersReq.new # SystemGroupMembersReq | 
}

begin
  #Manage the members of a System Group
  api_instance.graph_system_group_members_post(group_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_members_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupMembersReq**](SystemGroupMembersReq.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_system_group_membership**
> Array&lt;GraphObjectWithPaths&gt; graph_system_group_membership(group_id, content_type, accept, opts)

List the System Group's membership

This endpoint returns all Systems that are a member of this System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/membership ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the System Group's membership
  result = api_instance.graph_system_group_membership(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_membership: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_traverse_policy**
> Array&lt;GraphObjectWithPaths&gt; graph_system_group_traverse_policy(group_id, content_type, accept, opts)

List the Policies associated with a System Group

This endpoint will return Policies associated with a System Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this System Group to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  This endpoint is not public yet as we haven't finished the code.

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Policies associated with a System Group
  result = api_instance.graph_system_group_traverse_policy(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_system_group_traverse_user(group_id, content_type, accept, opts)

List the Users associated with a System Group

This endpoint will return Users associated with a System Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this System Group to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/users ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with a System Group
  result = api_instance.graph_system_group_traverse_user(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_group_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_system_group_traverse_user_group(group_id, content_type, accept, opts)

List the User Groups associated with a System Group

This endpoint will return User Groups associated with a System Group. Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this System Group to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/usergroups ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Groups associated with a System Group
  result = api_instance.graph_system_group_traverse_user_group(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
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



# **graph_system_member_of**
> Array&lt;GraphObjectWithPaths&gt; graph_system_member_of(system_id, content_type, accept, opts)

List the parent Groups of a System

This endpoint returns all the System Groups a System is a member of.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systems/{system_id}/memberof ```

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

api_instance = SwaggerClient::GraphApi.new

system_id = "system_id_example" # String | ObjectID of the System.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the parent Groups of a System
  result = api_instance.graph_system_member_of(system_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_member_of: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **system_id** | **String**| ObjectID of the System. | 
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



# **graph_system_traverse_policy**
> Array&lt;GraphObjectWithPaths&gt; graph_system_traverse_policy(system_id, content_type, accept, opts)

List the Policies associated with a System

This endpoint will return Policies associated with a System. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this System to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System.  See `/members` and `/associations` endpoints to manage those collections.  This endpoint is not yet public as we have finish the code.

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

api_instance = SwaggerClient::GraphApi.new

system_id = "system_id_example" # String | ObjectID of the System.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Policies associated with a System
  result = api_instance.graph_system_traverse_policy(system_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **system_id** | **String**| ObjectID of the System. | 
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



# **graph_system_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_system_traverse_user(system_id, content_type, accept, opts)

List the Users associated with a System

This endpoint will return Users associated with a System. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this System to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systems/{system_id}/users ```

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

api_instance = SwaggerClient::GraphApi.new

system_id = "system_id_example" # String | ObjectID of the System.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users associated with a System
  result = api_instance.graph_system_traverse_user(system_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **system_id** | **String**| ObjectID of the System. | 
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



# **graph_user_associations_list**
> Array&lt;GraphConnection&gt; graph_user_associations_list(user_id, targets, content_type, accept, opts)

List the associations of a User

This endpoint returns the _direct_ associations of a User.  A direct association can be a non-homogenous relationship between 2 different objects. for example Users and Systems.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/associations?targets=user_group ```

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

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_associations_list: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

user_id = "user_id_example" # String | ObjectID of the User.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a User
  api_instance.graph_user_associations_post(user_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_associations_post: #{e}"
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



# **graph_user_group_associations_list**
> Array&lt;GraphConnection&gt; graph_user_group_associations_list(group_id, targets, content_type, accept, opts)

List the associations of a User Group.

This endpoint returns the _direct_ associations of this User Group.  A direct association can be a non-homogenous relationship between 2 different objects. for example User Groups and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/associations?targets=user ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

targets = ["targets_example"] # Array<String> | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the associations of a User Group.
  result = api_instance.graph_user_group_associations_list(group_id, targets, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_associations_post**
> graph_user_group_associations_post(group_id, content_type, accept, opts)

Manage the associations of a User Group

This endpoint manages the _direct_ associations of this User Group.  A direct association can be a non-homogenous relationship between 2 different objects. for example User Groups and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/associations ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::UserGroupGraphManagementReq.new # UserGroupGraphManagementReq | 
}

begin
  #Manage the associations of a User Group
  api_instance.graph_user_group_associations_post(group_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**UserGroupGraphManagementReq**](UserGroupGraphManagementReq.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_user_group_member_of**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_member_of(group_id, content_type, accept, opts)

List the User Group's parents

This endpoint returns all User Groups a User Group is a member of.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/{group_id}/membersof ```  Not public yet, as the code is not finished,

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Group's parents
  result = api_instance.graph_user_group_member_of(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_member_of: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_members_list**
> Array&lt;GraphConnection&gt; graph_user_group_members_list(group_id, content_type, accept, opts)

List the members of a User Group

This endpoint returns the user members of a User Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/{group_id}/members ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the members of a User Group
  result = api_instance.graph_user_group_members_list(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_members_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_members_post**
> graph_user_group_members_post(group_id, content_type, accept, opts)

Manage the members of a User Group

This endpoint allows you to manage the user members of a User Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/{group_id}/members ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: SwaggerClient::UserGroupMembersReq.new # UserGroupMembersReq | 
}

begin
  #Manage the members of a User Group
  api_instance.graph_user_group_members_post(group_id, content_type, accept, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_members_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**UserGroupMembersReq**](UserGroupMembersReq.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_user_group_membership**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_membership(group_id, content_type, accept, opts)

List the User Group's membership

This endpoint returns all users members that are a member of this User Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/{group_id}/membership ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the User Group's membership
  result = api_instance.graph_user_group_membership(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_membership: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_active_directory**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_active_directory(group_id, content_type, accept, opts)

List the Active Directories associated with a User Group

This endpoint will return the Active Directories associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding Active Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/activedirectories ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Active Directories associated with a User Group
  result = api_instance.graph_user_group_traverse_active_directory(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_active_directory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_application**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_application(group_id, content_type, accept, opts)

List the Applications associated with a User Group

This endpoint will return Applications associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/applications ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Applications associated with a User Group
  result = api_instance.graph_user_group_traverse_application(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_application: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_directory**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_directory(group_id, content_type, accept, opts)

List the Directories associated with a User Group

This endpoint will return Directories associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directories from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/directories ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Directories associated with a User Group
  result = api_instance.graph_user_group_traverse_directory(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_directory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_g_suite**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_g_suite(group_id, content_type, accept, opts)

List the G Suite instances associated with a User Group

This endpoint will return the G Suite instances associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/gsuites ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the G Suite instances associated with a User Group
  result = api_instance.graph_user_group_traverse_g_suite(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_g_suite: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_ldap_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_ldap_server(group_id, content_type, accept, opts)

List the LDAP Servers associated with a User Group

This endpoint will return the LDAP Servers associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/ldapservers ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the LDAP Servers associated with a User Group
  result = api_instance.graph_user_group_traverse_ldap_server(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_ldap_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_office365**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_office365(group_id, content_type, accept, opts)

List the Office 365 instances associated with a User Group

This endpoint will return the Office 365 instances associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/office365s ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Office 365 instances associated with a User Group
  result = api_instance.graph_user_group_traverse_office365(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_office365: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_radius_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_radius_server(group_id, content_type, accept, opts)

List the RADIUS Servers associated with a User Group

This endpoint will return a RADIUS Servers associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/radiusservers ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the RADIUS Servers associated with a User Group
  result = api_instance.graph_user_group_traverse_radius_server(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_radius_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_system(group_id, content_type, accept, opts)

List the Systems associated with a User Group

This endpoint will return Systems associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/systems ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Systems associated with a User Group
  result = api_instance.graph_user_group_traverse_system(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_system_group(group_id, content_type, accept, opts)

List the System Groups associated with User Groups

This endpoint will return System Groups associated with a User Group. Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of attributes specifically set for this group.  The `paths` array enumerates each path from this User Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/usergroups/group_id}/systemsgroups ```

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

api_instance = SwaggerClient::GraphApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the System Groups associated with User Groups
  result = api_instance.graph_user_group_traverse_system_group(group_id, content_type, accept, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_member_of**
> Array&lt;GraphObjectWithPaths&gt; graph_user_member_of(user_id, content_type, accept, opts)

List the parent Groups of a User

This endpoint returns all the User Groups a User is a member of.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/users/{user_id}/memberof ```

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

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_member_of: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_application: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_directory: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_g_suite: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_ldap_server: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_office365: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_radius_server: #{e}"
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
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::GraphApi.new

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
rescue SwaggerClient::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_system: #{e}"
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



