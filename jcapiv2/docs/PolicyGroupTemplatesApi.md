# JCAPIv2::PolicyGroupTemplatesApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**policy_group_templates_delete**](PolicyGroupTemplatesApi.md#policy_group_templates_delete) | **DELETE** /providers/{provider_id}/policygrouptemplates/{id} | Deletes policy group template.
[**policy_group_templates_get**](PolicyGroupTemplatesApi.md#policy_group_templates_get) | **GET** /providers/{provider_id}/policygrouptemplates/{id} | Gets a provider&#x27;s policy group template.
[**policy_group_templates_get_configured_policy_template**](PolicyGroupTemplatesApi.md#policy_group_templates_get_configured_policy_template) | **GET** /providers/{provider_id}/configuredpolicytemplates/{id} | Retrieve a configured policy template by id.
[**policy_group_templates_list**](PolicyGroupTemplatesApi.md#policy_group_templates_list) | **GET** /providers/{provider_id}/policygrouptemplates | List a provider&#x27;s policy group templates.
[**policy_group_templates_list_configured_policy_templates**](PolicyGroupTemplatesApi.md#policy_group_templates_list_configured_policy_templates) | **GET** /providers/{provider_id}/configuredpolicytemplates | List a provider&#x27;s configured policy templates.
[**policy_group_templates_list_members**](PolicyGroupTemplatesApi.md#policy_group_templates_list_members) | **GET** /providers/{provider_id}/policygrouptemplates/{id}/members | Gets the list of members from a policy group template.

# **policy_group_templates_delete**
> policy_group_templates_delete(provider_id, id)

Deletes policy group template.

Deletes a Policy Group Template.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes policy group template.
  api_instance.policy_group_templates_delete(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_get**
> PolicyGroupTemplate policy_group_templates_get(provider_id, id)

Gets a provider's policy group template.

Retrieves a Policy Group Template for this provider.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a provider's policy group template.
  result = api_instance.policy_group_templates_get(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**PolicyGroupTemplate**](PolicyGroupTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_get_configured_policy_template**
> ConfiguredPolicyTemplate policy_group_templates_get_configured_policy_template(provider_id, id)

Retrieve a configured policy template by id.

Retrieves a Configured Policy Templates for this provider and Id.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Retrieve a configured policy template by id.
  result = api_instance.policy_group_templates_get_configured_policy_template(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_get_configured_policy_template: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**ConfiguredPolicyTemplate**](ConfiguredPolicyTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list**
> PolicyGroupTemplates policy_group_templates_list(provider_id, opts)

List a provider's policy group templates.

Retrieves a list of Policy Group Templates for this provider.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's policy group templates.
  result = api_instance.policy_group_templates_list(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**PolicyGroupTemplates**](PolicyGroupTemplates.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list_configured_policy_templates**
> InlineResponse20014 policy_group_templates_list_configured_policy_templates(provider_id, opts)

List a provider's configured policy templates.

Retrieves a list of Configured Policy Templates for this provider.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's configured policy templates.
  result = api_instance.policy_group_templates_list_configured_policy_templates(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list_configured_policy_templates: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**InlineResponse20014**](InlineResponse20014.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list_members**
> PolicyGroupTemplateMembers policy_group_templates_list_members(provider_id, id, opts)

Gets the list of members from a policy group template.

Retrieves a Policy Group Template's Members.

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

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Gets the list of members from a policy group template.
  result = api_instance.policy_group_templates_list_members(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**PolicyGroupTemplateMembers**](PolicyGroupTemplateMembers.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



