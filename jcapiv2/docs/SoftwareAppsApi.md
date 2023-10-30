# JCAPIv2::SoftwareAppsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_softwareapps_associations_list**](SoftwareAppsApi.md#graph_softwareapps_associations_list) | **GET** /softwareapps/{software_app_id}/associations | List the associations of a Software Application
[**graph_softwareapps_associations_post**](SoftwareAppsApi.md#graph_softwareapps_associations_post) | **POST** /softwareapps/{software_app_id}/associations | Manage the associations of a software application.
[**graph_softwareapps_traverse_system**](SoftwareAppsApi.md#graph_softwareapps_traverse_system) | **GET** /softwareapps/{software_app_id}/systems | List the Systems bound to a Software App.
[**graph_softwareapps_traverse_system_group**](SoftwareAppsApi.md#graph_softwareapps_traverse_system_group) | **GET** /softwareapps/{software_app_id}/systemgroups | List the System Groups bound to a Software App.
[**software_app_statuses_list**](SoftwareAppsApi.md#software_app_statuses_list) | **GET** /softwareapps/{software_app_id}/statuses | Get the status of the provided Software Application
[**software_apps_delete**](SoftwareAppsApi.md#software_apps_delete) | **DELETE** /softwareapps/{id} | Delete a configured Software Application
[**software_apps_get**](SoftwareAppsApi.md#software_apps_get) | **GET** /softwareapps/{id} | Retrieve a configured Software Application.
[**software_apps_list**](SoftwareAppsApi.md#software_apps_list) | **GET** /softwareapps | Get all configured Software Applications.
[**software_apps_post**](SoftwareAppsApi.md#software_apps_post) | **POST** /softwareapps | Create a Software Application that will be managed by JumpCloud.
[**software_apps_reclaim_licenses**](SoftwareAppsApi.md#software_apps_reclaim_licenses) | **POST** /softwareapps/{software_app_id}/reclaim-licenses | Reclaim Licenses for a Software Application.
[**software_apps_retry_installation**](SoftwareAppsApi.md#software_apps_retry_installation) | **POST** /softwareapps/{software_app_id}/retry-installation | Retry Installation for a Software Application
[**software_apps_update**](SoftwareAppsApi.md#software_apps_update) | **PUT** /softwareapps/{id} | Update a Software Application Configuration.

# **graph_softwareapps_associations_list**
> Array&lt;GraphConnection&gt; graph_softwareapps_associations_list(software_app_id, targets, opts)

List the associations of a Software Application

This endpoint will return the _direct_ associations of a Software Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Software Application and System Groups.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations?targets=system_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
targets = ['targets_example'] # Array<String> | Targets which a \"software_app\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Software Application
  result = api_instance.graph_softwareapps_associations_list(software_app_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_associations_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**| ObjectID of the Software App. | 
 **targets** | [**Array&lt;String&gt;**](String.md)| Targets which a \&quot;software_app\&quot; can be associated to. | 
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



# **graph_softwareapps_associations_post**
> graph_softwareapps_associations_post(software_app_id, opts)

Manage the associations of a software application.

This endpoint allows you to associate or disassociate a software application to a system or system group.  #### Sample Request ``` $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{   \"id\": \"<object_id>\",   \"op\": \"add\",   \"type\": \"system\"  }' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  body: JCAPIv2::GraphOperationSoftwareApp.new # GraphOperationSoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a software application.
  api_instance.graph_softwareapps_associations_post(software_app_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_associations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**| ObjectID of the Software App. | 
 **body** | [**GraphOperationSoftwareApp**](GraphOperationSoftwareApp.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_softwareapps_traverse_system**
> Array&lt;GraphObjectWithPaths&gt; graph_softwareapps_traverse_system(software_app_id, opts)

List the Systems bound to a Software App.

This endpoint will return all Systems bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Software App to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Software App.  See `/associations` endpoint to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_traverse_system: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**| ObjectID of the Software App. | 
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



# **graph_softwareapps_traverse_system_group**
> Array&lt;GraphObjectWithPaths&gt; graph_softwareapps_traverse_system_group(software_app_id, opts)

List the System Groups bound to a Software App.

This endpoint will return all Systems Groups bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Software App to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Software App.  See `/associations` endpoint to manage those collections.  #### Sample Request ``` curl -X GET  https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system_group(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_traverse_system_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**| ObjectID of the Software App. | 
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



# **software_app_statuses_list**
> Array&lt;SoftwareAppStatus&gt; software_app_statuses_list(software_app_id, opts)

Get the status of the provided Software Application

This endpoint allows you to get the status of the provided Software Application on associated JumpCloud systems.  #### Sample Request ``` $ curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/statuses \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Get the status of the provided Software Application
  result = api_instance.software_app_statuses_list(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_app_statuses_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**| ObjectID of the Software App. | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;SoftwareAppStatus&gt;**](SoftwareAppStatus.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **software_apps_delete**
> software_apps_delete(id, opts)

Delete a configured Software Application

Removes a Software Application configuration.  Warning: This is a destructive operation and will unmanage the application on all affected systems.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/softwareapps/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a configured Software Application
  api_instance.software_apps_delete(id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **software_apps_get**
> SoftwareApp software_apps_get(id, opts)

Retrieve a configured Software Application.

Retrieves a Software Application. The optional isConfigEnabled and appConfiguration apple_vpp attributes are populated in this response.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Retrieve a configured Software Application.
  result = api_instance.software_apps_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**SoftwareApp**](SoftwareApp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **software_apps_list**
> Array&lt;SoftwareApp&gt; software_apps_list(opts)

Get all configured Software Applications.

This endpoint allows you to get all configured Software Applications that will be managed by JumpCloud on associated JumpCloud systems. The optional isConfigEnabled and appConfiguration apple_vpp attributes are not included in the response.  #### Sample Request ``` $ curl -X GET https://console.jumpcloud.com/api/v2/softwareapps \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Get all configured Software Applications.
  result = api_instance.software_apps_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;SoftwareApp&gt;**](SoftwareApp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **software_apps_post**
> SoftwareApp software_apps_post(opts)

Create a Software Application that will be managed by JumpCloud.

This endpoint allows you to create a Software Application that will be managed by JumpCloud on associated JumpCloud systems. The optional isConfigEnabled and appConfiguration apple_vpp attributes are not included in the response.  #### Sample Request ``` $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{   \"displayName\": \"Adobe Reader\",   \"settings\": [{\"packageId\": \"adobereader\"}] }' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
opts = { 
  body: JCAPIv2::SoftwareApp.new # SoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a Software Application that will be managed by JumpCloud.
  result = api_instance.software_apps_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**SoftwareApp**](SoftwareApp.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**SoftwareApp**](SoftwareApp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **software_apps_reclaim_licenses**
> SoftwareAppReclaimLicenses software_apps_reclaim_licenses(software_app_id)

Reclaim Licenses for a Software Application.

This endpoint allows you to reclaim the licenses from a software app associated with devices that are deleted. #### Sample Request ``` $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/reclaim-licenses \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | 


begin
  #Reclaim Licenses for a Software Application.
  result = api_instance.software_apps_reclaim_licenses(software_app_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_reclaim_licenses: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **software_app_id** | **String**|  | 

### Return type

[**SoftwareAppReclaimLicenses**](SoftwareAppReclaimLicenses.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **software_apps_retry_installation**
> software_apps_retry_installation(bodysoftware_app_id)

Retry Installation for a Software Application

This endpoints initiates an installation retry of an Apple VPP App for the provided system IDs #### Sample Request ``` $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/retry-installation \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{\"system_ids\": \"{<system_id_1>, <system_id_2>, ...}\"}' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
body = JCAPIv2::SoftwareAppsRetryInstallationRequest.new # SoftwareAppsRetryInstallationRequest | 
software_app_id = 'software_app_id_example' # String | 


begin
  #Retry Installation for a Software Application
  api_instance.software_apps_retry_installation(bodysoftware_app_id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_retry_installation: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**SoftwareAppsRetryInstallationRequest**](SoftwareAppsRetryInstallationRequest.md)|  | 
 **software_app_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **software_apps_update**
> SoftwareApp software_apps_update(id, opts)

Update a Software Application Configuration.

This endpoint updates a specific Software Application configuration for the organization. displayName can be changed alone if no settings are provided. If a setting is provided, it should include all its information since this endpoint will update all the settings' fields. The optional isConfigEnabled and appConfiguration apple_vpp attributes are not included in the response.  #### Sample Request - displayName only ```  curl -X PUT https://console.jumpcloud.com/api/v2/softwareapps/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"displayName\": \"My Software App\"   }' ```  #### Sample Request - all attributes ```  curl -X PUT https://console.jumpcloud.com/api/v2/softwareapps/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"displayName\": \"My Software App\",     \"settings\": [       {         \"packageId\": \"123456\",         \"autoUpdate\": false,         \"allowUpdateDelay\": false,         \"packageManager\": \"APPLE_VPP\",         \"locationObjectId\": \"123456789012123456789012\",         \"location\": \"123456\",         \"desiredState\": \"Install\",         \"appleVpp\": {           \"appConfiguration\": \"<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?><!DOCTYPE plist PUBLIC \\\"-//Apple//DTD PLIST 1.0//EN\\\" \\\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\\\"><plist version=\\\"1.0\\\"><dict><key>MyKey</key><string>My String</string></dict></plist>\",           \"assignedLicenses\": 20,           \"availableLicenses\": 10,           \"details\": {},           \"isConfigEnabled\": true,           \"supportedDeviceFamilies\": [             \"IPAD\",             \"MAC\"           ],           \"totalLicenses\": 30         },         \"packageSubtitle\": \"My package subtitle\",         \"packageVersion\": \"1.2.3\",         \"packageKind\": \"software-package\",         \"assetKind\": \"software\",         \"assetSha256Size\": 256,         \"assetSha256Strings\": [           \"a123b123c123d123\"         ],         \"description\": \"My app description\"       }     ]   }' ```

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

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::SoftwareApp.new # SoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a Software Application Configuration.
  result = api_instance.software_apps_update(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**SoftwareApp**](SoftwareApp.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**SoftwareApp**](SoftwareApp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



