# JCAPIv2::RADIUSServersApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_radius_server_associations_list**](RADIUSServersApi.md#graph_radius_server_associations_list) | **GET** /radiusservers/{radiusserver_id}/associations | List the associations of a RADIUS  Server
[**graph_radius_server_associations_post**](RADIUSServersApi.md#graph_radius_server_associations_post) | **POST** /radiusservers/{radiusserver_id}/associations | Manage the associations of a RADIUS Server
[**graph_radius_server_traverse_user**](RADIUSServersApi.md#graph_radius_server_traverse_user) | **GET** /radiusservers/{radiusserver_id}/users | List the Users bound to a RADIUS  Server
[**graph_radius_server_traverse_user_group**](RADIUSServersApi.md#graph_radius_server_traverse_user_group) | **GET** /radiusservers/{radiusserver_id}/usergroups | List the User Groups bound to a RADIUS  Server

# **graph_radius_server_associations_list**
> Array&lt;GraphConnection&gt; graph_radius_server_associations_list(radiusserver_id, targets, opts)

List the associations of a RADIUS  Server

This endpoint returns the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations?targets=user_group \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
targets = ['targets_example'] # Array<String> | Targets which a \"radius_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a RADIUS  Server
  result = api_instance.graph_radius_server_associations_list(radiusserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;radius_server\&quot; can be associated to. | 
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



# **graph_radius_server_associations_post**
> graph_radius_server_associations_post(radiusserver_id, opts)

Manage the associations of a RADIUS Server

This endpoint allows you to manage the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"type\":\"user\",  \"id\":\"{USER_ID}\",  \"op\":\"add\"   }' ```

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

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  body: JCAPIv2::GraphOperationRadiusServer.new # GraphOperationRadiusServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a RADIUS Server
  api_instance.graph_radius_server_associations_post(radiusserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
 **body** | [**GraphOperationRadiusServer**](GraphOperationRadiusServer.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_radius_server_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_radius_server_traverse_user(radiusserver_id, opts)

List the Users bound to a RADIUS  Server

This endpoint will return all Users bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



# **graph_radius_server_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_radius_server_traverse_user_group(radiusserver_id, opts)

List the User Groups bound to a RADIUS  Server

This endpoint will return all Users Groups bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user_group(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **radiusserver_id** | **String**| ObjectID of the Radius Server. | 
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



