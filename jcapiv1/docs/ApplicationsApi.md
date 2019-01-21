# JCAPIv1::ApplicationsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applications_list**](ApplicationsApi.md#applications_list) | **GET** /applications | Applications


# **applications_list**
> Applicationslist applications_list(content_type, accept, opts)

Applications

The endpoint returns all your SSO / SAML Applications.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/applications \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```

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

api_instance = JCAPIv1::ApplicationsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "fields_example", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: "The comma separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.", # String | 
  x_org_id: "" # String | 
}

begin
  #Applications
  result = api_instance.applications_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_list: #{e}"
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
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Applicationslist**](Applicationslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



