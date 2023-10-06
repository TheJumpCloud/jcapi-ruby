# JCAPIv2::CommandResultsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commands_list_results_by_workflow**](CommandResultsApi.md#commands_list_results_by_workflow) | **GET** /commandresult/workflows | List all Command Results by Workflow

# **commands_list_results_by_workflow**
> CommandResultList commands_list_results_by_workflow(opts)

List all Command Results by Workflow

This endpoint returns all command results, grouped by workflowInstanceId.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commandresult/workflows \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key:{API_KEY}'   ```

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

api_instance = JCAPIv2::CommandResultsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List all Command Results by Workflow
  result = api_instance.commands_list_results_by_workflow(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandResultsApi->commands_list_results_by_workflow: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **limit** | **Integer**|  | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**CommandResultList**](CommandResultList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



