# JCAPIv1::ApplicationTemplatesApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**application_templates_get**](ApplicationTemplatesApi.md#application_templates_get) | **GET** /application-templates/{id} | Get an Application Template
[**application_templates_list**](ApplicationTemplatesApi.md#application_templates_list) | **GET** /application-templates | List Application Templates


# **application_templates_get**
> Applicationtemplate application_templates_get(id, content_type, accept, opts)

Get an Application Template

The endpoint returns a specific SSO / SAML Application Template.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/application-templates/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationTemplatesApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "fields_example", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: "The comma separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.", # String | 
  filter: "filter_example" # String | A filter to apply to the query.
  x_org_id: "" # String | 
}

begin
  #Get an Application Template
  result = api_instance.application_templates_get(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationTemplatesApi->application_templates_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned. | [optional] 
 **limit** | **Integer**| The number of records to return at once. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] 
 **sort** | **String**|  | [optional] [default to The comma separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.]
 **filter** | **String**| A filter to apply to the query. | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Applicationtemplate**](Applicationtemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **application_templates_list**
> Applicationtemplateslist application_templates_list(content_type, accept, opts)

List Application Templates

The endpoint returns all the SSO / SAML Application Templates.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/application-templates \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationTemplatesApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "fields_example", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: "The comma separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.", # String | 
  filter: "filter_example" # String | A filter to apply to the query.
  x_org_id: "" # String | 
}

begin
  #List Application Templates
  result = api_instance.application_templates_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationTemplatesApi->application_templates_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned. | [optional] 
 **limit** | **Integer**| The number of records to return at once. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] 
 **sort** | **String**|  | [optional] [default to The comma separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.]
 **filter** | **String**| A filter to apply to the query. | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Applicationtemplateslist**](Applicationtemplateslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



