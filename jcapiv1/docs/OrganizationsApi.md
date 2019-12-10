# JCAPIv1::OrganizationsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**organization_list**](OrganizationsApi.md#organization_list) | **GET** /organizations | Get Organization Details
[**organization_put**](OrganizationsApi.md#organization_put) | **PUT** /organizations/{id} | Update an Organization
[**organizations_get**](OrganizationsApi.md#organizations_get) | **GET** /organizations/{id} | Get an Organization


# **organization_list**
> Organizationslist organization_list(content_type, accept, opts)

Get Organization Details

This endpoint returns Organization Details.  #### Sample Request   ``` curl -X GET \\   https://console.jumpcloud.com/api/organizations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv1::OrganizationsApi.new

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: "filter_example" # String | A filter to apply to the query.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: "", # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  search: "search_example", # String | A nested object containing a string `searchTerm` and a list of `fields` to search on.
}

begin
  #Get Organization Details
  result = api_instance.organization_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **search** | **String**| A nested object containing a string &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to search on. | [optional] 

### Return type

[**Organizationslist**](Organizationslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **organization_put**
> Organization organization_put(id, content_type, accept, opts)

Update an Organization

This endpoint allows you to update an Organization.  Note: `passwordPolicy` settings are only used when `passwordCompliance` is set to \"custom\". We discourage the use of non-custom passwordCompliance values.  `hasStripeCustomerId` is deprecated and will be removed.  #### Sample Request  ``` curl -X PUT https://console.jumpcloud.com/api/organizations/{OrganizationID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"settings\": {     \"contactName\": \"Admin Name\",     \"contactEmail\": \"admin@company.com\",     \"systemUsersCanEdit\":true,     \"passwordPolicy\": {       \"enableMaxHistory\": true,       \"maxHistory\": 3     }   } }' ```

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

api_instance = JCAPIv1::OrganizationsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv1::Body.new # Body | 
}

begin
  #Update an Organization
  result = api_instance.organization_put(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Body**](Body.md)|  | [optional] 

### Return type

[**Organization**](Organization.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **organizations_get**
> organizations_get(id, content_type, accept, opts)

Get an Organization

This endpoint returns a particular Organization.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/organizations/{OrganizationID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv1::OrganizationsApi.new

id = "id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  fields: "", # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: "filter_example" # String | A filter to apply to the query.
}

begin
  #Get an Organization
  api_instance.organizations_get(id, content_type, accept, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organizations_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



