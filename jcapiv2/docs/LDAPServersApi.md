# JCAPIv2::LDAPServersApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_ldap_server_associations_list**](LDAPServersApi.md#graph_ldap_server_associations_list) | **GET** /ldapservers/{ldapserver_id}/associations | List the associations of a LDAP Server
[**graph_ldap_server_associations_post**](LDAPServersApi.md#graph_ldap_server_associations_post) | **POST** /ldapservers/{ldapserver_id}/associations | Manage the associations of a LDAP Server
[**graph_ldap_server_traverse_user**](LDAPServersApi.md#graph_ldap_server_traverse_user) | **GET** /ldapservers/{ldapserver_id}/users | List the Users bound to a LDAP Server
[**graph_ldap_server_traverse_user_group**](LDAPServersApi.md#graph_ldap_server_traverse_user_group) | **GET** /ldapservers/{ldapserver_id}/usergroups | List the User Groups bound to a LDAP Server
[**ldapservers_get**](LDAPServersApi.md#ldapservers_get) | **GET** /ldapservers/{id} | Get LDAP Server
[**ldapservers_list**](LDAPServersApi.md#ldapservers_list) | **GET** /ldapservers | List LDAP Servers
[**ldapservers_patch**](LDAPServersApi.md#ldapservers_patch) | **PATCH** /ldapservers/{id} | Update existing LDAP server

# **graph_ldap_server_associations_list**
> Array&lt;GraphConnection&gt; graph_ldap_server_associations_list(ldapserver_id, targets, opts)

List the associations of a LDAP Server

This endpoint returns the _direct_ associations of this LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request  ```  curl -X GET 'https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
targets = ['targets_example'] # Array<String> | Targets which a \"ldap_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a LDAP Server
  result = api_instance.graph_ldap_server_associations_list(ldapserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;ldap_server\&quot; can be associated to. | 
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



# **graph_ldap_server_associations_post**
> graph_ldap_server_associations_post(ldapserver_id, opts)

Manage the associations of a LDAP Server

This endpoint allows you to manage the _direct_ associations of a LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"{User_ID}\"   }' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  body: JCAPIv2::GraphOperationLdapServer.new # GraphOperationLdapServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a LDAP Server
  api_instance.graph_ldap_server_associations_post(ldapserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
 **body** | [**GraphOperationLdapServer**](GraphOperationLdapServer.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_ldap_server_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_ldap_server_traverse_user(ldapserver_id, opts)

List the Users bound to a LDAP Server

This endpoint will return all Users bound to an LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **graph_ldap_server_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_ldap_server_traverse_user_group(ldapserver_id, opts)

List the User Groups bound to a LDAP Server

This endpoint will return all Users Groups bound to a LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user_group(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| ObjectID of the LDAP Server. | 
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



# **ldapservers_get**
> LdapServerOutput ldapservers_get(id, opts)

Get LDAP Server

This endpoint returns a specific LDAP server.  ##### Sample Request  ```  curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
id = 'id_example' # String | Unique identifier of the LDAP server.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get LDAP Server
  result = api_instance.ldapservers_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the LDAP server. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**LdapServerOutput**](LdapServerOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **ldapservers_list**
> Array&lt;LdapServerOutput&gt; ldapservers_list(opts)

List LDAP Servers

This endpoint returns the object IDs of your LDAP servers.   ##### Sample Request  ```   curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'

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

api_instance = JCAPIv2::LDAPServersApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List LDAP Servers
  result = api_instance.ldapservers_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;LdapServerOutput&gt;**](LdapServerOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **ldapservers_patch**
> InlineResponse20010 ldapservers_patch(id, opts)

Update existing LDAP server

This endpoint allows updating some attributes of an LDAP server.  Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"userLockoutAction\": \"remove\",     \"userPasswordExpirationAction\": \"disable\"   }' ```

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

api_instance = JCAPIv2::LDAPServersApi.new
id = 'id_example' # String | Unique identifier of the LDAP server.
opts = { 
  body: JCAPIv2::LdapserversIdBody.new # LdapserversIdBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing LDAP server
  result = api_instance.ldapservers_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the LDAP server. | 
 **body** | [**LdapserversIdBody**](LdapserversIdBody.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**InlineResponse20010**](InlineResponse20010.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



