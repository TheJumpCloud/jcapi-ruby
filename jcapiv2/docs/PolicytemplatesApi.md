# JCAPIv2::PolicytemplatesApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**policytemplates_get**](PolicytemplatesApi.md#policytemplates_get) | **GET** /policytemplates/{id} | Get a specific Policy Template
[**policytemplates_list**](PolicytemplatesApi.md#policytemplates_list) | **GET** /policytemplates | Lists all of the Policy Templates


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

api_instance = JCAPIv2::PolicytemplatesApi.new

id = "id_example" # String | ObjectID of the Policy Template.

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Get a specific Policy Template
  result = api_instance.policytemplates_get(id, content_type, accept)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicytemplatesApi->policytemplates_get: #{e}"
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

api_instance = JCAPIv2::PolicytemplatesApi.new

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
  puts "Exception when calling PolicytemplatesApi->policytemplates_list: #{e}"
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



