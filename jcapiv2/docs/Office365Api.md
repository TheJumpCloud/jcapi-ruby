# JCAPIv2::Office365Api

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_office365_associations_list**](Office365Api.md#graph_office365_associations_list) | **GET** /office365s/{office365_id}/associations | List the associations of an Office 365 instance
[**graph_office365_associations_post**](Office365Api.md#graph_office365_associations_post) | **POST** /office365s/{office365_id}/associations | Manage the associations of an Office 365 instance
[**graph_office365_traverse_user**](Office365Api.md#graph_office365_traverse_user) | **GET** /office365s/{office365_id}/users | List the Users bound to an Office 365 instance
[**graph_office365_traverse_user_group**](Office365Api.md#graph_office365_traverse_user_group) | **GET** /office365s/{office365_id}/usergroups | List the User Groups bound to an Office 365 instance
[**office365s_get**](Office365Api.md#office365s_get) | **GET** /office365s/{office365_id} | Get Office 365 instance
[**office365s_list_import_users**](Office365Api.md#office365s_list_import_users) | **GET** /office365s/{office365_id}/import/users | Get a list of users to import from an Office 365 instance
[**office365s_patch**](Office365Api.md#office365s_patch) | **PATCH** /office365s/{office365_id} | Update existing Office 365 instance.
[**translation_rules_office365_delete**](Office365Api.md#translation_rules_office365_delete) | **DELETE** /office365s/{office365_id}/translationrules/{id} | Deletes a Office 365 translation rule
[**translation_rules_office365_get**](Office365Api.md#translation_rules_office365_get) | **GET** /office365s/{office365_id}/translationrules/{id} | Gets a specific Office 365 translation rule
[**translation_rules_office365_list**](Office365Api.md#translation_rules_office365_list) | **GET** /office365s/{office365_id}/translationrules | List all the Office 365 Translation Rules
[**translation_rules_office365_post**](Office365Api.md#translation_rules_office365_post) | **POST** /office365s/{office365_id}/translationrules | Create a new Office 365 Translation Rule

# **graph_office365_associations_list**
> Array&lt;GraphConnection&gt; graph_office365_associations_list(office365_id, targets, opts)

List the associations of an Office 365 instance

This endpoint returns _direct_ associations of an Office 365 instance.   A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations?targets=user_group' \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
targets = ['targets_example'] # Array<String> | Targets which a \"office_365\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Office 365 instance
  result = api_instance.graph_office365_associations_list(office365_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;office_365\&quot; can be associated to. | 
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



# **graph_office365_associations_post**
> graph_office365_associations_post(office365_id, opts)

Manage the associations of an Office 365 instance

This endpoint allows you to manage the _direct_ associations of a Office 365 instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  body: JCAPIv2::GraphOperationOffice365.new # GraphOperationOffice365 | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Office 365 instance
  api_instance.graph_office365_associations_post(office365_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
 **body** | [**GraphOperationOffice365**](GraphOperationOffice365.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_office365_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_office365_traverse_user(office365_id, opts)

List the Users bound to an Office 365 instance

This endpoint will return all Users bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 suite. | 
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



# **graph_office365_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_office365_traverse_user_group(office365_id, opts)

List the User Groups bound to an Office 365 instance

This endpoint will return all Users Groups bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user_group(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 suite. | 
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



# **office365s_get**
> Office365Output office365s_get(office365_id, opts)

Get Office 365 instance

This endpoint returns a specific Office 365 instance.  #####  Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Office 365 instance
  result = api_instance.office365s_get(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Office365Output**](Office365Output.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **office365s_list_import_users**
> InlineResponse20011 office365s_list_import_users(office365_id, opts)

Get a list of users to import from an Office 365 instance

Lists Office 365 users available for import.

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  consistency_level: 'consistency_level_example', # String | Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#request-headers
  top: 56, # Integer | Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging.
  skip_token: 'skip_token_example', # String | Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging.
  filter: 'filter_example', # String | Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  search: 'search_example', # String | Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  orderby: 'orderby_example', # String | Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  count: true # BOOLEAN | Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
}

begin
  #Get a list of users to import from an Office 365 instance
  result = api_instance.office365s_list_import_users(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_list_import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **consistency_level** | **String**| Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#request-headers | [optional] 
 **top** | **Integer**| Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging. | [optional] 
 **skip_token** | **String**| Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging. | [optional] 
 **filter** | **String**| Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **search** | **String**| Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **orderby** | **String**| Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 
 **count** | **BOOLEAN**| Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view&#x3D;graph-rest-1.0&amp;tabs&#x3D;http#optional-query-parameters. | [optional] 

### Return type

[**InlineResponse20011**](InlineResponse20011.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **office365s_patch**
> Office365Output office365s_patch(office365_id, opts)

Update existing Office 365 instance.

This endpoint allows updating some attributes of an Office 365 instance.  #####  Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"userLockoutAction\": \"maintain\",     \"userPasswordExpirationAction\": \"suspend\"   }' ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  body: JCAPIv2::Office365PatchInput.new # Office365PatchInput | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing Office 365 instance.
  result = api_instance.office365s_patch(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**| ObjectID of the Office 365 instance. | 
 **body** | [**Office365PatchInput**](Office365PatchInput.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Office365Output**](Office365Output.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **translation_rules_office365_delete**
> translation_rules_office365_delete(office365_id, id)

Deletes a Office 365 translation rule

This endpoint allows you to delete a translation rule for a specific Office 365 instance. These rules specify how JumpCloud attributes translate to [Microsoft Graph](https://developer.microsoft.com/en-us/graph) attributes.  #### Sample Request  ``` curl -X DELETE https://console.jumpcloud.com/api/v2/office365s/{office365_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes a Office 365 translation rule
  api_instance.translation_rules_office365_delete(office365_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined



# **translation_rules_office365_get**
> Office365TranslationRule translation_rules_office365_get(office365_id, id)

Gets a specific Office 365 translation rule

This endpoint returns a specific translation rule for a specific Office 365 instance. These rules specify how JumpCloud attributes translate to [Microsoft Graph](https://developer.microsoft.com/en-us/graph) attributes.  ###### Sample Request  ```   curl -X GET https://console.jumpcloud.com/api/v2/office365s/{office365_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a specific Office 365 translation rule
  result = api_instance.translation_rules_office365_get(office365_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**Office365TranslationRule**](Office365TranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **translation_rules_office365_list**
> Array&lt;Office365TranslationRule&gt; translation_rules_office365_list(office365_id, opts)

List all the Office 365 Translation Rules

This endpoint returns all translation rules for a specific Office 365 instance. These rules specify how JumpCloud attributes translate to [Microsoft Graph](https://developer.microsoft.com/en-us/graph) attributes.  ##### Sample Request  ```  curl -X GET  https://console.jumpcloud.com/api/v2/office365s/{office365_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all the Office 365 Translation Rules
  result = api_instance.translation_rules_office365_list(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;Office365TranslationRule&gt;**](Office365TranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **translation_rules_office365_post**
> Office365TranslationRule translation_rules_office365_post(office365_id, opts)

Create a new Office 365 Translation Rule

This endpoint allows you to create a translation rule for a specific Office 365 instance. These rules specify how JumpCloud attributes translate to [Microsoft Graph](https://developer.microsoft.com/en-us/graph) attributes.  ##### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/office365s/{office365_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     {Translation Rule Parameters}   }' ```

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

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  body: JCAPIv2::Office365TranslationRuleRequest.new # Office365TranslationRuleRequest | 
}

begin
  #Create a new Office 365 Translation Rule
  result = api_instance.translation_rules_office365_post(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **office365_id** | **String**|  | 
 **body** | [**Office365TranslationRuleRequest**](Office365TranslationRuleRequest.md)|  | [optional] 

### Return type

[**Office365TranslationRule**](Office365TranslationRule.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



