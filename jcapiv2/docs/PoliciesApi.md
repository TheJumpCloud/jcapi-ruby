# JCAPIv2::PoliciesApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_policy_associations_list**](PoliciesApi.md#graph_policy_associations_list) | **GET** /policies/{policy_id}/associations | List the associations of a Policy
[**graph_policy_associations_post**](PoliciesApi.md#graph_policy_associations_post) | **POST** /policies/{policy_id}/associations | Manage the associations of a Policy
[**graph_policy_traverse_system**](PoliciesApi.md#graph_policy_traverse_system) | **GET** /policies/{policy_id}/systems | List the Systems associated with a Policy
[**graph_policy_traverse_system_group**](PoliciesApi.md#graph_policy_traverse_system_group) | **GET** /policies/{policy_id}/systemgroups | List the System Groups associated with a Policy
[**policies_delete**](PoliciesApi.md#policies_delete) | **DELETE** /policies/{id} | Deletes a Policy
[**policies_get**](PoliciesApi.md#policies_get) | **GET** /policies/{id} | Gets a specific Policy.
[**policies_list**](PoliciesApi.md#policies_list) | **GET** /policies | Lists all the Policies
[**policies_post**](PoliciesApi.md#policies_post) | **POST** /policies | Create a new Policy
[**policies_put**](PoliciesApi.md#policies_put) | **PUT** /policies/{id} | Update an existing Policy
[**policyresults_get**](PoliciesApi.md#policyresults_get) | **GET** /policyresults/{id} | Get a specific Policy Result.
[**policyresults_list**](PoliciesApi.md#policyresults_list) | **GET** /policyresults | Lists all the policy results for an organization.
[**policyresults_list_0**](PoliciesApi.md#policyresults_list_0) | **GET** /policies/{policy_id}/policyresults | Lists all the policy results of a given policy.
[**policytemplates_get**](PoliciesApi.md#policytemplates_get) | **GET** /policytemplates/{id} | Get a specific Policy Template
[**policytemplates_list**](PoliciesApi.md#policytemplates_list) | **GET** /policytemplates | Lists all of the Policy Templates


# **graph_policy_associations_list**
> Array&lt;GraphConnection&gt; graph_policy_associations_list(policy_id, targets, content_type, accept, opts)

List the associations of a Policy

This endpoint returns the _direct_ associations of a Policy.  A direct association can be a non-homogenous relationship between 2 different objects. for example Policies and Systems.  #### Sample Request ``` https://console.jumpcloud.com/api/v2/policies/{policy_id}/associations?targets=system ```

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

api_instance = JCAPIv2::PoliciesApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_associations_list: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new

policy_id = "policy_id_example" # String | ObjectID of the Policy.

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::GraphManagementReq.new # GraphManagementReq | 
}

begin
  #Manage the associations of a Policy
  api_instance.graph_policy_associations_post(policy_id, content_type, accept, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_associations_post: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_traverse_system: #{e}"
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
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new

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
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_traverse_system_group: #{e}"
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



# **policies_delete**
> policies_delete(id, content_type, accept)

Deletes a Policy

This endpoint allows you to delete a policy.

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

api_instance = JCAPIv2::PoliciesApi.new

id = "id_example" # String | ObjectID of the Policy object.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Deletes a Policy
  api_instance.policies_delete(id, content_type, accept)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Policy object. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policies_get**
> PolicyWithDetails policies_get(id, content_type, accept)

Gets a specific Policy.

This endpoint returns a specific policy.

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

api_instance = JCAPIv2::PoliciesApi.new

id = "id_example" # String | ObjectID of the Policy object.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Gets a specific Policy.
  result = api_instance.policies_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Policy object. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**PolicyWithDetails**](PolicyWithDetails.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policies_list**
> Array&lt;Policy&gt; policies_list(content_type, accept, opts)

Lists all the Policies

This endpoint returns all policies.

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

api_instance = JCAPIv2::PoliciesApi.new

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
  #Lists all the Policies
  result = api_instance.policies_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_list: #{e}"
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

[**Array&lt;Policy&gt;**](Policy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policies_post**
> PolicyWithDetails policies_post(content_type, accept, opts)

Create a new Policy

This endpoint allows you to create a policy.

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

api_instance = JCAPIv2::PoliciesApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::PolicyRequest.new # PolicyRequest | 
}

begin
  #Create a new Policy
  result = api_instance.policies_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**PolicyRequest**](PolicyRequest.md)|  | [optional] 

### Return type

[**PolicyWithDetails**](PolicyWithDetails.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policies_put**
> Policy policies_put(id, , opts)

Update an existing Policy

This endpoint allows you to update a policy.

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

api_instance = JCAPIv2::PoliciesApi.new

id = "id_example" # String | ObjectID of the Policy object.

opts = { 
  body: JCAPIv2::PolicyRequest.new # PolicyRequest | 
}

begin
  #Update an existing Policy
  result = api_instance.policies_put(id, , opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Policy object. | 
 **body** | [**PolicyRequest**](PolicyRequest.md)|  | [optional] 

### Return type

[**Policy**](Policy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policyresults_get**
> PolicyResult policyresults_get(id, content_type, accept)

Get a specific Policy Result.

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

api_instance = JCAPIv2::PoliciesApi.new

id = "id_example" # String | ObjectID of the Policy Result.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get a specific Policy Result.
  result = api_instance.policyresults_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Policy Result. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**PolicyResult**](PolicyResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policyresults_list**
> Array&lt;PolicyResult&gt; policyresults_list(content_type, accept, opts)

Lists all the policy results for an organization.

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

api_instance = JCAPIv2::PoliciesApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  aggregate: "" # String | 
}

begin
  #Lists all the policy results for an organization.
  result = api_instance.policyresults_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_list: #{e}"
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
 **aggregate** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;PolicyResult&gt;**](PolicyResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policyresults_list_0**
> Array&lt;PolicyResult&gt; policyresults_list_0(policy_id, content_type, accept, opts)

Lists all the policy results of a given policy.

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

api_instance = JCAPIv2::PoliciesApi.new

policy_id = "policy_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "", # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  aggregate: "" # String | 
}

begin
  #Lists all the policy results of a given policy.
  result = api_instance.policyresults_list_0(policy_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_list_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| Supported operators are: eq, ne, gt, ge, lt, le, between, search | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **aggregate** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;PolicyResult&gt;**](PolicyResult.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policytemplates_get**
> PolicyTemplateWithDetails policytemplates_get(id, content_type, accept)

Get a specific Policy Template

This endpoint returns a specific policy template.

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

api_instance = JCAPIv2::PoliciesApi.new

id = "id_example" # String | ObjectID of the Policy Template.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get a specific Policy Template
  result = api_instance.policytemplates_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policytemplates_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Policy Template. | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**PolicyTemplateWithDetails**](PolicyTemplateWithDetails.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **policytemplates_list**
> Array&lt;PolicyTemplate&gt; policytemplates_list(content_type, accept, opts)

Lists all of the Policy Templates

This endpoint returns all policy templates.

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

api_instance = JCAPIv2::PoliciesApi.new

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
  #Lists all of the Policy Templates
  result = api_instance.policytemplates_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policytemplates_list: #{e}"
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

[**Array&lt;PolicyTemplate&gt;**](PolicyTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



