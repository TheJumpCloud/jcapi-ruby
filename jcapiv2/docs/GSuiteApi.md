# JCAPIv2::GSuiteApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_g_suite_associations_list**](GSuiteApi.md#graph_g_suite_associations_list) | **GET** /gsuites/{gsuite_id}/associations | List the associations of a G Suite instance
[**graph_g_suite_associations_post**](GSuiteApi.md#graph_g_suite_associations_post) | **POST** /gsuites/{gsuite_id}/associations | Manage the associations of a G Suite instance
[**graph_g_suite_traverse_user**](GSuiteApi.md#graph_g_suite_traverse_user) | **GET** /gsuites/{gsuite_id}/users | List the Users bound to a G Suite instance
[**graph_g_suite_traverse_user_group**](GSuiteApi.md#graph_g_suite_traverse_user_group) | **GET** /gsuites/{gsuite_id}/usergroups | List the User Groups bound to a G Suite instance
[**gsuites_get**](GSuiteApi.md#gsuites_get) | **GET** /gsuites/{id} | Get G Suite
[**gsuites_list_import_jumpcloud_users**](GSuiteApi.md#gsuites_list_import_jumpcloud_users) | **GET** /gsuites/{gsuite_id}/import/jumpcloudusers | Get a list of users in Jumpcloud format to import from a Google Workspace account.
[**gsuites_list_import_users**](GSuiteApi.md#gsuites_list_import_users) | **GET** /gsuites/{gsuite_id}/import/users | Get a list of users to import from a G Suite instance
[**gsuites_patch**](GSuiteApi.md#gsuites_patch) | **PATCH** /gsuites/{id} | Update existing G Suite
[**translation_rules_g_suite_delete**](GSuiteApi.md#translation_rules_g_suite_delete) | **DELETE** /gsuites/{gsuite_id}/translationrules/{id} | Deletes a G Suite translation rule
[**translation_rules_g_suite_get**](GSuiteApi.md#translation_rules_g_suite_get) | **GET** /gsuites/{gsuite_id}/translationrules/{id} | Gets a specific G Suite translation rule
[**translation_rules_g_suite_list**](GSuiteApi.md#translation_rules_g_suite_list) | **GET** /gsuites/{gsuite_id}/translationrules | List all the G Suite Translation Rules
[**translation_rules_g_suite_post**](GSuiteApi.md#translation_rules_g_suite_post) | **POST** /gsuites/{gsuite_id}/translationrules | Create a new G Suite Translation Rule

# **graph_g_suite_associations_list**
> Array&lt;GraphConnection&gt; graph_g_suite_associations_list(gsuite_id, targets, opts)

List the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
targets = ['targets_example'] # Array<String> | Targets which a \"g_suite\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a G Suite instance
  result = api_instance.graph_g_suite_associations_list(gsuite_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;g_suite\&quot; can be associated to. | 
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



# **graph_g_suite_associations_post**
> graph_g_suite_associations_post(gsuite_id, opts)

Manage the associations of a G Suite instance

This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  body: JCAPIv2::GraphOperationGSuite.new # GraphOperationGSuite | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a G Suite instance
  api_instance.graph_g_suite_associations_post(gsuite_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
 **body** | [**GraphOperationGSuite**](GraphOperationGSuite.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_g_suite_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_g_suite_traverse_user(gsuite_id, opts)

List the Users bound to a G Suite instance

This endpoint will return all Users bound to a G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
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



# **graph_g_suite_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_g_suite_traverse_user_group(gsuite_id, opts)

List the User Groups bound to a G Suite instance

This endpoint will return all User Groups bound to an G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSuite_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user_group(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**| ObjectID of the G Suite instance. | 
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



# **gsuites_get**
> GsuiteOutput gsuites_get(id, opts)

Get G Suite

This endpoint returns a specific G Suite.  ##### Sample Request  ```  curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::GSuiteApi.new
id = 'id_example' # String | Unique identifier of the GSuite.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get G Suite
  result = api_instance.gsuites_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the GSuite. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**GsuiteOutput**](GsuiteOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **gsuites_list_import_jumpcloud_users**
> InlineResponse2001 gsuites_list_import_jumpcloud_users(gsuite_id, opts)

Get a list of users in Jumpcloud format to import from a Google Workspace account.

Lists available G Suite users for import, translated to the Jumpcloud user schema.

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users in Jumpcloud format to import from a Google Workspace account.
  result = api_instance.gsuites_list_import_jumpcloud_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_list_import_jumpcloud_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **max_results** | **Integer**| Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **order_by** | **String**| Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **page_token** | **String**| Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **query** | **String**| Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users. | [optional] 
 **sort_order** | **String**| Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 

### Return type

[**InlineResponse2001**](InlineResponse2001.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **gsuites_list_import_users**
> InlineResponse2002 gsuites_list_import_users(gsuite_id, opts)

Get a list of users to import from a G Suite instance

Lists G Suite users available for import.

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users to import from a G Suite instance
  result = api_instance.gsuites_list_import_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_list_import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **max_results** | **Integer**| Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **order_by** | **String**| Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **page_token** | **String**| Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 
 **query** | **String**| Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users. | [optional] 
 **sort_order** | **String**| Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list. | [optional] 

### Return type

[**InlineResponse2002**](InlineResponse2002.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **gsuites_patch**
> GsuiteOutput gsuites_patch(id, opts)

Update existing G Suite

This endpoint allows updating some attributes of a G Suite.  ##### Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"userLockoutAction\": \"suspend\",     \"userPasswordExpirationAction\": \"maintain\"   }' ```

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::GSuiteApi.new
id = 'id_example' # String | Unique identifier of the GSuite.
opts = { 
  body: JCAPIv2::GsuitePatchInput.new # GsuitePatchInput | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing G Suite
  result = api_instance.gsuites_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the GSuite. | 
 **body** | [**GsuitePatchInput**](GsuitePatchInput.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**GsuiteOutput**](GsuiteOutput.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **translation_rules_g_suite_delete**
> translation_rules_g_suite_delete(gsuite_id, id)

Deletes a G Suite translation rule

This endpoint allows you to delete a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  #### Sample Request  ``` curl -X DELETE https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes a G Suite translation rule
  api_instance.translation_rules_g_suite_delete(gsuite_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined



# **translation_rules_g_suite_get**
> GSuiteTranslationRule translation_rules_g_suite_get(gsuite_id, id)

Gets a specific G Suite translation rule

This endpoint returns a specific translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ###### Sample Request  ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a specific G Suite translation rule
  result = api_instance.translation_rules_g_suite_get(gsuite_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**GSuiteTranslationRule**](GSuiteTranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **translation_rules_g_suite_list**
> Array&lt;GSuiteTranslationRule&gt; translation_rules_g_suite_list(gsuite_id, opts)

List all the G Suite Translation Rules

This endpoint returns all graph translation rules for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request  ```  curl -X GET  https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all the G Suite Translation Rules
  result = api_instance.translation_rules_g_suite_list(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;GSuiteTranslationRule&gt;**](GSuiteTranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **translation_rules_g_suite_post**
> GSuiteTranslationRule translation_rules_g_suite_post(gsuite_id, opts)

Create a new G Suite Translation Rule

This endpoint allows you to create a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     {Translation Rule Parameters}   }' ```

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

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  body: JCAPIv2::GSuiteTranslationRuleRequest.new # GSuiteTranslationRuleRequest | 
}

begin
  #Create a new G Suite Translation Rule
  result = api_instance.translation_rules_g_suite_post(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gsuite_id** | **String**|  | 
 **body** | [**GSuiteTranslationRuleRequest**](GSuiteTranslationRuleRequest.md)|  | [optional] 

### Return type

[**GSuiteTranslationRule**](GSuiteTranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



