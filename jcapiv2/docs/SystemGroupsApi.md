# JCAPIv2::SystemGroupsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_system_group_associations_list**](SystemGroupsApi.md#graph_system_group_associations_list) | **GET** /systemgroups/{group_id}/associations | List the associations of a System Group
[**graph_system_group_associations_post**](SystemGroupsApi.md#graph_system_group_associations_post) | **POST** /systemgroups/{group_id}/associations | Manage the associations of a System Group
[**graph_system_group_member_of**](SystemGroupsApi.md#graph_system_group_member_of) | **GET** /systemgroups/{group_id}/memberof | List the System Group&#39;s parents
[**graph_system_group_members_list**](SystemGroupsApi.md#graph_system_group_members_list) | **GET** /systemgroups/{group_id}/members | List the members of a System Group
[**graph_system_group_members_post**](SystemGroupsApi.md#graph_system_group_members_post) | **POST** /systemgroups/{group_id}/members | Manage the members of a System Group
[**graph_system_group_membership**](SystemGroupsApi.md#graph_system_group_membership) | **GET** /systemgroups/{group_id}/membership | List the System Group&#39;s membership
[**graph_system_group_traverse_policy**](SystemGroupsApi.md#graph_system_group_traverse_policy) | **GET** /systemgroups/{group_id}/policies | List the Policies associated with a System Group
[**graph_system_group_traverse_user**](SystemGroupsApi.md#graph_system_group_traverse_user) | **GET** /systemgroups/{group_id}/users | List the Users associated with a System Group
[**graph_system_group_traverse_user_group**](SystemGroupsApi.md#graph_system_group_traverse_user_group) | **GET** /systemgroups/{group_id}/usergroups | List the User Groups associated with a System Group
[**groups_system_delete**](SystemGroupsApi.md#groups_system_delete) | **DELETE** /systemgroups/{id} | Delete a System Group
[**groups_system_get**](SystemGroupsApi.md#groups_system_get) | **GET** /systemgroups/{id} | View an individual System Group details
[**groups_system_list**](SystemGroupsApi.md#groups_system_list) | **GET** /systemgroups | List all System Groups
[**groups_system_patch**](SystemGroupsApi.md#groups_system_patch) | **PATCH** /systemgroups/{id} | Partial update a System Group
[**groups_system_post**](SystemGroupsApi.md#groups_system_post) | **POST** /systemgroups | Create a new System Group
[**groups_system_put**](SystemGroupsApi.md#groups_system_put) | **PUT** /systemgroups/{id} | Update a System Group


# **graph_system_group_associations_list**
> Array&lt;GraphConnection&gt; graph_system_group_associations_list(group_id, targets, content_type, accept, opts)

List the associations of a System Group

This endpoint returns the _direct_ associations of a System Group.  A direct association can be a non-homogenous relationship between 2 different objects. for example System Groups and Users.   #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{group_id}/associations?targets=user ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_associations_list: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::SystemGroupGraphManagementReq.new # SystemGroupGraphManagementReq | 
}

begin
  #Manage the associations of a System Group
  api_instance.graph_system_group_associations_post(group_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_associations_post: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_member_of: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_members_list: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

group_id = "group_id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::SystemGroupMembersReq.new, # SystemGroupMembersReq | 
  date: "date_example", # String | Current date header for the System Context API
  authorization: "authorization_example" # String | Authorization header for the System Context API
}

begin
  #Manage the members of a System Group
  api_instance.graph_system_group_members_post(group_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_members_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupMembersReq**](SystemGroupMembersReq.md)|  | [optional] 
 **date** | **String**| Current date header for the System Context API | [optional] 
 **authorization** | **String**| Authorization header for the System Context API | [optional] 

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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_membership: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_policy: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_user: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_user_group: #{e}"
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



# **groups_system_delete**
> groups_system_delete(id, content_type, accept)

Delete a System Group

This endpoint allows you to delete a System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{id} ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

id = "id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete a System Group
  api_instance.groups_system_delete(id, content_type, accept)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **groups_system_get**
> SystemGroup groups_system_get(id, content_type, accept)

View an individual System Group details

This endpoint returns the details of a System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{id} ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

id = "id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #View an individual System Group details
  result = api_instance.groups_system_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**SystemGroup**](SystemGroup.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **groups_system_list**
> Array&lt;SystemGroup&gt; groups_system_list(content_type, accept, opts)

List all System Groups

This endpoint returns all System Groups.  Available filter fields:   - `name`   - `disabled`   - `type`  #### Sample Request  ``` https://console.jumpcloud.com/api/v2/systemgroups ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all System Groups
  result = api_instance.groups_system_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_list: #{e}"
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

[**Array&lt;SystemGroup&gt;**](SystemGroup.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **groups_system_patch**
> SystemGroup groups_system_patch(id, content_type, accept, opts)

Partial update a System Group

We have hidden PATCH on the systemgroups and usergroups for now; we don't have that implemented correctly yet, people should use PUT until we do a true PATCH operation.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{id} ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

id = "id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::SystemGroupData.new # SystemGroupData | 
}

begin
  #Partial update a System Group
  result = api_instance.groups_system_patch(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupData**](SystemGroupData.md)|  | [optional] 

### Return type

[**SystemGroup**](SystemGroup.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **groups_system_post**
> SystemGroup groups_system_post(content_type, accept, opts)

Create a new System Group

This endpoint allows you to create a new System Group.  #### Sample Request  ``` https://console.jumpcloud.com/api/v2/systemgroups ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::SystemGroupData.new # SystemGroupData | 
}

begin
  #Create a new System Group
  result = api_instance.groups_system_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupData**](SystemGroupData.md)|  | [optional] 

### Return type

[**SystemGroup**](SystemGroup.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **groups_system_put**
> SystemGroup groups_system_put(id, content_type, accept, opts)

Update a System Group

This enpoint allows you to do a full update of the System Group.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/systemgroups/{id} ```

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

api_instance = JCAPIv2::SystemGroupsApi.new

id = "id_example" # String | ObjectID of the System Group.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::SystemGroupData.new # SystemGroupData | 
}

begin
  #Update a System Group
  result = api_instance.groups_system_put(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the System Group. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**SystemGroupData**](SystemGroupData.md)|  | [optional] 

### Return type

[**SystemGroup**](SystemGroup.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



