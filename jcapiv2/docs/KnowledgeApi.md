# JCAPIv2::KnowledgeApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**knowledge_articles_list**](KnowledgeApi.md#knowledge_articles_list) | **GET** /knowledge/articles | List Knowledge Articles
[**knowledge_salesforce_list**](KnowledgeApi.md#knowledge_salesforce_list) | **GET** /knowledge/salesforce | List Knowledge Articles


# **knowledge_articles_list**
> SalesforceKnowledgeListOutput knowledge_articles_list(opts)

List Knowledge Articles

This endpoint returns a list of knowledge articles hosted in salesforce.  ``` Sample Request curl -X GET https://console.jumpcloud.com/api/v2/knowledge/articles \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::KnowledgeApi.new

opts = { 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | 
}

begin
  #List Knowledge Articles
  result = api_instance.knowledge_articles_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling KnowledgeApi->knowledge_articles_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**|  | [optional] [default to 10]

### Return type

[**SalesforceKnowledgeListOutput**](SalesforceKnowledgeListOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **knowledge_salesforce_list**
> SalesforceKnowledgeListOutput knowledge_salesforce_list(opts)

List Knowledge Articles

This endpoint returns a list of knowledge articles hosted in salesforce.  ``` Sample Request curl -X GET https://console.jumpcloud.com/api/v2/knowledge/articles \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::KnowledgeApi.new

opts = { 
  fields: ["fields_example"], # Array<String> | 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Knowledge Articles
  result = api_instance.knowledge_salesforce_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling KnowledgeApi->knowledge_salesforce_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fields** | [**Array&lt;String&gt;**](String.md)|  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**SalesforceKnowledgeListOutput**](SalesforceKnowledgeListOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



