# JCAPIv1::TagsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tags_delete**](TagsApi.md#tags_delete) | **DELETE** /tags/{name} | Delete a Tag
[**tags_get**](TagsApi.md#tags_get) | **GET** /Tags/{name} | List a Tag
[**tags_list**](TagsApi.md#tags_list) | **GET** /tags | List All Tags
[**tags_post**](TagsApi.md#tags_post) | **POST** /tags | Create a Tag
[**tags_put**](TagsApi.md#tags_put) | **PUT** /Tag/{name} | Update a Tag


# **tags_delete**
> Tag tags_delete(name, content_type, accept)

Delete a Tag

Hidden as Tags is deprecated  Delete a Tag.

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

api_instance = JCAPIv1::TagsApi.new

name = "name_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Delete a Tag
  result = api_instance.tags_delete(name, content_type, accept)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling TagsApi->tags_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

[**Tag**](Tag.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tags_get**
> Tag tags_get(name, content_type, accept, opts)

List a Tag

Hidden as Tags is deprecated  Returns a specific tag.

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

api_instance = JCAPIv1::TagsApi.new

name = "name_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: "", # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  filter: "filter_example" # String | A filter to apply to the query.
}

begin
  #List a Tag
  result = api_instance.tags_get(name, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling TagsApi->tags_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 

### Return type

[**Tag**](Tag.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tags_list**
> Tagslist tags_list(content_type, accept, opts)

List All Tags

Hidden as Tags is deprecated  Returns all Tags.

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

api_instance = JCAPIv1::TagsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: "", # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  filter: "filter_example" # String | A filter to apply to the query.
}

begin
  #List All Tags
  result = api_instance.tags_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling TagsApi->tags_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 

### Return type

[**Tagslist**](Tagslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tags_post**
> Tag tags_post(content_type, accept, opts)

Create a Tag

Hidden as Tags is deprecated  Create a tag.  ### Examples #### Create a new Tag  ``` curl \\   -d '{\"name\" : \"Developers\"}' \\   -X 'POST' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/tags\" ```

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

api_instance = JCAPIv1::TagsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Tagpost.new # Tagpost | 
}

begin
  #Create a Tag
  result = api_instance.tags_post(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling TagsApi->tags_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Tagpost**](Tagpost.md)|  | [optional] 

### Return type

[**Tag**](Tag.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tags_put**
> Tag tags_put(name, content_type, accept, opts)

Update a Tag

Hidden as Tags is deprecated  Update a specific tag.

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

api_instance = JCAPIv1::TagsApi.new

name = "name_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Tagput.new # Tagput | 
}

begin
  #Update a Tag
  result = api_instance.tags_put(name, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling TagsApi->tags_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Tagput**](Tagput.md)|  | [optional] 

### Return type

[**Tag**](Tag.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



