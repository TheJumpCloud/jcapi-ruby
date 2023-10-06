# JCAPIv2::AuthenticationPoliciesApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authnpolicies_delete**](AuthenticationPoliciesApi.md#authnpolicies_delete) | **DELETE** /authn/policies/{id} | Delete Authentication Policy
[**authnpolicies_get**](AuthenticationPoliciesApi.md#authnpolicies_get) | **GET** /authn/policies/{id} | Get an authentication policy
[**authnpolicies_list**](AuthenticationPoliciesApi.md#authnpolicies_list) | **GET** /authn/policies | List Authentication Policies
[**authnpolicies_patch**](AuthenticationPoliciesApi.md#authnpolicies_patch) | **PATCH** /authn/policies/{id} | Patch Authentication Policy
[**authnpolicies_post**](AuthenticationPoliciesApi.md#authnpolicies_post) | **POST** /authn/policies | Create an Authentication Policy

# **authnpolicies_delete**
> AuthnPolicy authnpolicies_delete(id, opts)

Delete Authentication Policy

Delete the specified authentication policy.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/authn/policies/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Authentication Policy
  result = api_instance.authnpolicies_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the authentication policy | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AuthnPolicy**](AuthnPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **authnpolicies_get**
> AuthnPolicy authnpolicies_get(id, opts)

Get an authentication policy

Return a specific authentication policy.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/authn/policies/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an authentication policy
  result = api_instance.authnpolicies_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the authentication policy | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AuthnPolicy**](AuthnPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **authnpolicies_list**
> Array&lt;AuthnPolicy&gt; authnpolicies_list(opts)

List Authentication Policies

Get a list of all authentication policies.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/authn/policies \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  x_total_count: 56, # Integer | 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Authentication Policies
  result = api_instance.authnpolicies_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **x_total_count** | **Integer**|  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Array&lt;AuthnPolicy&gt;**](AuthnPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **authnpolicies_patch**
> AuthnPolicy authnpolicies_patch(id, opts)

Patch Authentication Policy

Patch the specified authentication policy.  #### Sample Request ``` curl -X PATCH https://console.jumpcloud.com/api/v2/authn/policies/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ \"disabled\": false }' ```

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

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  body: JCAPIv2::AuthnPolicy.new # AuthnPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Patch Authentication Policy
  result = api_instance.authnpolicies_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Unique identifier of the authentication policy | 
 **body** | [**AuthnPolicy**](AuthnPolicy.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AuthnPolicy**](AuthnPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **authnpolicies_post**
> AuthnPolicy authnpolicies_post(opts)

Create an Authentication Policy

Create an authentication policy.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/authn/policies \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Sample Policy\",     \"disabled\": false,     \"effect\": {       \"action\": \"allow\"     },     \"targets\": {       \"users\": {         \"inclusions\": [\"ALL\"]       },       \"userGroups\": {         \"exclusions\": [{USER_GROUP_ID}]       },       \"resources\": [ {\"type\": \"user_portal\" } ]     },     \"conditions\":{       \"ipAddressIn\": [{IP_LIST_ID}]     }   }' ```

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

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
opts = { 
  body: JCAPIv2::AuthnPolicy.new # AuthnPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create an Authentication Policy
  result = api_instance.authnpolicies_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**AuthnPolicy**](AuthnPolicy.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AuthnPolicy**](AuthnPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



