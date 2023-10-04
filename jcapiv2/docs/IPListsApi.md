# JCAPIv2::IPListsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**iplists_delete**](IPListsApi.md#iplists_delete) | **DELETE** /iplists/{id} | Delete an IP list
[**iplists_get**](IPListsApi.md#iplists_get) | **GET** /iplists/{id} | Get an IP list
[**iplists_list**](IPListsApi.md#iplists_list) | **GET** /iplists | List IP Lists
[**iplists_patch**](IPListsApi.md#iplists_patch) | **PATCH** /iplists/{id} | Update an IP list
[**iplists_post**](IPListsApi.md#iplists_post) | **POST** /iplists | Create IP List
[**iplists_put**](IPListsApi.md#iplists_put) | **PUT** /iplists/{id} | Replace an IP list

# **iplists_delete**
> IPList iplists_delete(id, opts)

Delete an IP list

Delete a specific IP list.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/iplists/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete an IP list
  result = api_instance.iplists_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**IPList**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **iplists_get**
> IPList iplists_get(id, opts)

Get an IP list

Return a specific IP list.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/iplists/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an IP list
  result = api_instance.iplists_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**IPList**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **iplists_list**
> Array&lt;IPList&gt; iplists_list(opts)

List IP Lists

Retrieve all IP lists.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/iplists \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::IPListsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  x_total_count: 56, # Integer | 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List IP Lists
  result = api_instance.iplists_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_list: #{e}"
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

[**Array&lt;IPList&gt;**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **iplists_patch**
> IPList iplists_patch(id, opts)

Update an IP list

Update a specific IP list.  #### Sample Request ``` curl -X PATCH https://console.jumpcloud.com/api/v2/iplists/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"name\": \"New IP List Name\"}' ```

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

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::IPListRequest.new # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update an IP list
  result = api_instance.iplists_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_patch: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**IPListRequest**](IPListRequest.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**IPList**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **iplists_post**
> IPList iplists_post(opts)

Create IP List

Create an IP list.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/iplists \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Sample IP List\",     \"ips\": [       \"192.168.10.12\",       \"192.168.10.20 - 192.168.10.30\",       \"123.225.10.0/32\"     ]   }' ```

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

api_instance = JCAPIv2::IPListsApi.new
opts = { 
  body: JCAPIv2::IPListRequest.new # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create IP List
  result = api_instance.iplists_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**IPListRequest**](IPListRequest.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**IPList**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **iplists_put**
> IPList iplists_put(id, opts)

Replace an IP list

Replace a specific IP list.  #### Sample Request ``` curl -X PUT https://console.jumpcloud.com/api/v2/iplists/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Sample IP List\",     \"ips\": [       \"192.168.10.10\"     ]   }' ```

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

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::IPListRequest.new # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Replace an IP list
  result = api_instance.iplists_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**IPListRequest**](IPListRequest.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**IPList**](IPList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



