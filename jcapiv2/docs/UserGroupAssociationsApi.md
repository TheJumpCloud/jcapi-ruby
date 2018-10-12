# JCAPIv2::UserGroupAssociationsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_user_group_associations_list**](UserGroupAssociationsApi.md#graph_user_group_associations_list) | **GET** /usergroups/{group_id}/associations | List the associations of a User Group.
[**graph_user_group_associations_post**](UserGroupAssociationsApi.md#graph_user_group_associations_post) | **POST** /usergroups/{group_id}/associations | Manage the associations of a User Group
[**graph_user_group_traverse_active_directory**](UserGroupAssociationsApi.md#graph_user_group_traverse_active_directory) | **GET** /usergroups/{group_id}/activedirectories | List the Active Directories bound to a User Group
[**graph_user_group_traverse_application**](UserGroupAssociationsApi.md#graph_user_group_traverse_application) | **GET** /usergroups/{group_id}/applications | List the Applications bound to a User Group
[**graph_user_group_traverse_directory**](UserGroupAssociationsApi.md#graph_user_group_traverse_directory) | **GET** /usergroups/{group_id}/directories | List the Directories bound to a User Group
[**graph_user_group_traverse_g_suite**](UserGroupAssociationsApi.md#graph_user_group_traverse_g_suite) | **GET** /usergroups/{group_id}/gsuites | List the G Suite instances bound to a User Group
[**graph_user_group_traverse_ldap_server**](UserGroupAssociationsApi.md#graph_user_group_traverse_ldap_server) | **GET** /usergroups/{group_id}/ldapservers | List the LDAP Servers bound to a User Group
[**graph_user_group_traverse_office365**](UserGroupAssociationsApi.md#graph_user_group_traverse_office365) | **GET** /usergroups/{group_id}/office365s | List the Office 365 instances bound to a User Group
[**graph_user_group_traverse_radius_server**](UserGroupAssociationsApi.md#graph_user_group_traverse_radius_server) | **GET** /usergroups/{group_id}/radiusservers | List the RADIUS Servers bound to a User Group
[**graph_user_group_traverse_system**](UserGroupAssociationsApi.md#graph_user_group_traverse_system) | **GET** /usergroups/{group_id}/systems | List the Systems bound to a User Group
[**graph_user_group_traverse_system_group**](UserGroupAssociationsApi.md#graph_user_group_traverse_system_group) | **GET** /usergroups/{group_id}/systemgroups | List the System Groups bound to User Groups


# **graph_user_group_associations_list**
> Array&lt;GraphConnection&gt; graph_user_group_associations_list(group_id, content_type, accepttargets, opts)

List the associations of a User Group.

This endpoint returns the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations?targets=system \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

targets = ["targets_example"] # Array<String> | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the associations of a User Group.
  result = api_instance.graph_user_group_associations_list(group_id, content_type, accepttargets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **targets** | [**Array&lt;String&gt;**](String.md)|  | 
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



# **graph_user_group_associations_post**
> graph_user_group_associations_post(group_id, content_type, accept, opts)

Manage the associations of a User Group

This endpoint manages the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system\",     \"id\": \"{SystemID}\" }'  ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::UserGroupGraphManagementReq.new, # UserGroupGraphManagementReq | 
  x_org_id: "" # String | 
}

begin
  #Manage the associations of a User Group
  api_instance.graph_user_group_associations_post(group_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**UserGroupGraphManagementReq**](UserGroupGraphManagementReq.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **graph_user_group_traverse_active_directory**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_active_directory(group_id, content_type, accept, opts)

List the Active Directories bound to a User Group

This endpoint will return all Active Directory Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.   The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Active Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/activedirectories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the Active Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_active_directory(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_active_directory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_application**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_application(group_id, content_type, accept, opts)

List the Applications bound to a User Group

This endpoint will return all Applications bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/applications \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the Applications bound to a User Group
  result = api_instance.graph_user_group_traverse_application(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_application: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_directory**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_directory(group_id, content_type, accept, opts)

List the Directories bound to a User Group

This endpoint will return all Directories bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directories from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/directories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_directory(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_directory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_g_suite**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_g_suite(group_id, content_type, accept, opts)

List the G Suite instances bound to a User Group

This endpoint will return all G Suite Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID/gsuites \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the G Suite instances bound to a User Group
  result = api_instance.graph_user_group_traverse_g_suite(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_g_suite: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_ldap_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_ldap_server(group_id, content_type, accept, opts)

List the LDAP Servers bound to a User Group

This endpoint will return all LDAP Servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/ldapservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the LDAP Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_ldap_server(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_ldap_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_office365**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_office365(group_id, content_type, accept, opts)

List the Office 365 instances bound to a User Group

This endpoint will return all Office 365 instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/office365s \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the Office 365 instances bound to a User Group
  result = api_instance.graph_user_group_traverse_office365(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_office365: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_radius_server**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_radius_server(group_id, content_type, accept, opts)

List the RADIUS Servers bound to a User Group

This endpoint will return all RADIUS servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.    Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/radiusservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the RADIUS Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_radius_server(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_radius_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_system(group_id, content_type, accept, opts)

List the Systems bound to a User Group

This endpoint will return all Systems bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.    Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the Systems bound to a User Group
  result = api_instance.graph_user_group_traverse_system(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



# **graph_user_group_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_user_group_traverse_system_group(group_id, content_type, accept, opts)

List the System Groups bound to User Groups

This endpoint will return all System Groups bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.    Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::UserGroupAssociationsApi.new

group_id = "group_id_example" # String | ObjectID of the User Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: "" # String | 
}

begin
  #List the System Groups bound to User Groups
  result = api_instance.graph_user_group_traverse_system_group(group_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the User Group. | 
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



