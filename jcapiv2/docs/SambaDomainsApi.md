# SwaggerClient::SambaDomainsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ldapservers_samba_domains_delete**](SambaDomainsApi.md#ldapservers_samba_domains_delete) | **DELETE** /ldapservers/{ldapserver_id}/sambadomains/{id} | Delete Samba Domain
[**ldapservers_samba_domains_get**](SambaDomainsApi.md#ldapservers_samba_domains_get) | **GET** /ldapservers/{ldapserver_id}/sambadomains/{id} | Get Samba Domain
[**ldapservers_samba_domains_list**](SambaDomainsApi.md#ldapservers_samba_domains_list) | **GET** /ldapservers/{ldapserver_id}/sambadomains | List Samba Domains
[**ldapservers_samba_domains_post**](SambaDomainsApi.md#ldapservers_samba_domains_post) | **POST** /ldapservers/{ldapserver_id}/sambadomains | Create Samba Domain
[**ldapservers_samba_domains_put**](SambaDomainsApi.md#ldapservers_samba_domains_put) | **PUT** /ldapservers/{ldapserver_id}/sambadomains/{id} | Update Samba Domain


# **ldapservers_samba_domains_delete**
> String ldapservers_samba_domains_delete(ldapserver_id, id, opts)

Delete Samba Domain

This endpoint allows you to delete a samba domain from an LDAP server.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier o f the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json" # String | 
}

begin
  #Delete Samba Domain
  result = api_instance.ldapservers_samba_domains_delete(ldapserver_id, id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier o f the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]

### Return type

**String**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **ldapservers_samba_domains_get**
> SambaDomainOutput ldapservers_samba_domains_get(ldapserver_id, id, opts)

Get Samba Domain

This endpoint returns a specific samba domain for an LDAP server.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier o f the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json" # String | 
}

begin
  #Get Samba Domain
  result = api_instance.ldapservers_samba_domains_get(ldapserver_id, id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier o f the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]

### Return type

[**SambaDomainOutput**](SambaDomainOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **ldapservers_samba_domains_list**
> Array&lt;SambaDomainOutput&gt; ldapservers_samba_domains_list(ldapserver_id, opts)

List Samba Domains

This endpoint returns all samba domains for an LDAP server.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  fields: "", # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: "", # String | Supported operators are: eq, ne, gt, ge, lt, le, between, search
  limit: 10, # Integer | The number of records to return at once.
  skip: 0 # Integer | The offset into the records to return.
  sort: "" # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Samba Domains
  result = api_instance.ldapservers_samba_domains_list(ldapserver_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| Supported operators are: eq, ne, gt, ge, lt, le, between, search | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]

### Return type

[**Array&lt;SambaDomainOutput&gt;**](SambaDomainOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **ldapservers_samba_domains_post**
> SambaDomainOutput ldapservers_samba_domains_post(ldapserver_id, opts)

Create Samba Domain

This endpoint allows you to create a samba domain for an LDAP server.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

opts = { 
  body: SwaggerClient::SambaDomainInput.new, # SambaDomainInput | 
  content_type: "application/json", # String | 
  accept: "application/json" # String | 
}

begin
  #Create Samba Domain
  result = api_instance.ldapservers_samba_domains_post(ldapserver_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **body** | [**SambaDomainInput**](SambaDomainInput.md)|  | [optional] 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]

### Return type

[**SambaDomainOutput**](SambaDomainOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **ldapservers_samba_domains_put**
> SambaDomainOutput ldapservers_samba_domains_put(ldapserver_id, id, opts)

Update Samba Domain

This endpoint allows you to update the samba domain information for an LDAP server.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = SwaggerClient::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier o f the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  body: SwaggerClient::SambaDomainInput.new, # SambaDomainInput | 
  content_type: "application/json", # String | 
  accept: "application/json" # String | 
}

begin
  #Update Samba Domain
  result = api_instance.ldapservers_samba_domains_put(ldapserver_id, id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier o f the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **body** | [**SambaDomainInput**](SambaDomainInput.md)|  | [optional] 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]

### Return type

[**SambaDomainOutput**](SambaDomainOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



