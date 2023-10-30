# JCAPIv2::ApplicationsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applications_delete_logo**](ApplicationsApi.md#applications_delete_logo) | **DELETE** /applications/{application_id}/logo | Delete application image
[**applications_get**](ApplicationsApi.md#applications_get) | **GET** /applications/{application_id} | Get an Application
[**applications_post_logo**](ApplicationsApi.md#applications_post_logo) | **POST** /applications/{application_id}/logo | 
[**graph_application_associations_list**](ApplicationsApi.md#graph_application_associations_list) | **GET** /applications/{application_id}/associations | List the associations of an Application
[**graph_application_associations_post**](ApplicationsApi.md#graph_application_associations_post) | **POST** /applications/{application_id}/associations | Manage the associations of an Application
[**graph_application_traverse_user**](ApplicationsApi.md#graph_application_traverse_user) | **GET** /applications/{application_id}/users | List the Users bound to an Application
[**graph_application_traverse_user_group**](ApplicationsApi.md#graph_application_traverse_user_group) | **GET** /applications/{application_id}/usergroups | List the User Groups bound to an Application
[**import_users**](ApplicationsApi.md#import_users) | **GET** /applications/{application_id}/import/users | Get a list of users to import from an Application IdM service provider

# **applications_delete_logo**
> applications_delete_logo(application_id, opts)

Delete application image

Deletes the specified image from an application

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete application image
  api_instance.applications_delete_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_delete_logo: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applications_get**
> Object applications_get(application_id, opts)

Get an Application

The endpoint retrieves an Application.

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an Application
  result = api_instance.applications_get(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applications_post_logo**
> applications_post_logo(application_id, opts)



This endpoint sets the logo for an application.  #### Sample Request ``` curl -X POST 'https://console.jumpcloud.com/api/v2/applications/{Application_ID}/logo \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | 
opts = { 
  image: 'image_example' # String | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  api_instance.applications_post_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_post_logo: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**|  | 
 **image** | **String**|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json



# **graph_application_associations_list**
> Array&lt;GraphConnection&gt; graph_application_associations_list(application_id, targets, opts)

List the associations of an Application

This endpoint will return the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Applications and User Groups.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
targets = ['targets_example'] # Array<String> | Targets which a \"application\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Application
  result = api_instance.graph_application_associations_list(application_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;application\&quot; can be associated to. | 
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



# **graph_application_associations_post**
> graph_application_associations_post(application_id, opts)

Manage the associations of an Application

This endpoint allows you to manage the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Application and User Groups.  #### Sample Request ``` curl -X POST 'https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations' \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  body: JCAPIv2::GraphOperationApplication.new # GraphOperationApplication | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Application
  api_instance.graph_application_associations_post(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
 **body** | [**GraphOperationApplication**](GraphOperationApplication.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_application_traverse_user**
> Array&lt;GraphObjectWithPaths&gt; graph_application_traverse_user(application_id, opts)

List the Users bound to an Application

This endpoint will return all Users bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Application to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Application
  result = api_instance.graph_application_traverse_user(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_traverse_user: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **graph_application_traverse_user_group**
> Array&lt;GraphObjectWithPaths&gt; graph_application_traverse_user_group(application_id, opts)

List the User Groups bound to an Application

This endpoint will return all Users Groups bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates  each path from this Application to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Application
  result = api_instance.graph_application_traverse_user_group(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_traverse_user_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
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



# **import_users**
> ImportUsersResponse import_users(application_id, opts)

Get a list of users to import from an Application IdM service provider

Get a list of users to import from an Application IdM service provider.

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

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  filter: 'filter_example', # String | Filter users by a search term
  query: 'query_example', # String | URL query to merge with the service provider request
  sort: 'sort_example', # String | Sort users by supported fields
  sort_order: 'asc', # String | 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get a list of users to import from an Application IdM service provider
  result = api_instance.import_users(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->import_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **application_id** | **String**| ObjectID of the Application. | 
 **filter** | **String**| Filter users by a search term | [optional] 
 **query** | **String**| URL query to merge with the service provider request | [optional] 
 **sort** | **String**| Sort users by supported fields | [optional] 
 **sort_order** | **String**|  | [optional] [default to asc]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**ImportUsersResponse**](ImportUsersResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



