# JCAPIv2::SambaDomainsApi

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

This endpoint allows you to delete a samba domain from an LDAP server.  ##### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/sambadomains/{SAMBA_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  x_org_id: "<<your org id>>" # String | 
}

begin
  #Delete Samba Domain
  result = api_instance.ldapservers_samba_domains_delete(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to &lt;&lt;your org id&gt;&gt;]

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

This endpoint returns a specific samba domain for an LDAP server.  ##### Sample Request ``` curl -X GET \\   https://console.jumpcloud.com/api/v2/ldapservers/ldapservers/{LDAP_ID}/sambadomains/{SAMBA_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  x_org_id: "<<your org id>>" # String | 
}

begin
  #Get Samba Domain
  result = api_instance.ldapservers_samba_domains_get(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to &lt;&lt;your org id&gt;&gt;]

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

This endpoint returns all samba domains for an LDAP server.  ##### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/sambadomains \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv2::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

opts = { 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  fields: ["fields_example"], # Array<String> | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: ["filter_example"], # Array<String> | Supported operators are: eq, ne, gt, ge, lt, le, between, search, in
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ["sort_example"], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: "<<your org id>>" # String | 
}

begin
  #List Samba Domains
  result = api_instance.ldapservers_samba_domains_list(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq, ne, gt, ge, lt, le, between, search, in | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to &lt;&lt;your org id&gt;&gt;]

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

This endpoint allows you to create a samba domain for an LDAP server.  ##### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/sambadomains \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ \"sid\":\"{SID_ID}\",  \"name\":\"{WORKGROUP_NAME}\"  }' ```

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

api_instance = JCAPIv2::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

opts = { 
  body: JCAPIv2::SambaDomainInput.new, # SambaDomainInput | 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  x_org_id: "<<your org id>>" # String | 
}

begin
  #Create Samba Domain
  result = api_instance.ldapservers_samba_domains_post(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
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
 **x_org_id** | **String**|  | [optional] [default to &lt;&lt;your org id&gt;&gt;]

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

This endpoint allows you to update the samba domain information for an LDAP server.  ##### Sample Request ``` curl -X PUT https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/sambadomains/{SAMBA_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ \"sid\":\"{SID_ID}\",  \"name\":\"{WORKGROUP_NAME}\" }'  ```

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

api_instance = JCAPIv2::SambaDomainsApi.new

ldapserver_id = "ldapserver_id_example" # String | Unique identifier of the LDAP server.

id = "id_example" # String | Unique identifier of the samba domain.

opts = { 
  body: JCAPIv2::SambaDomainInput.new, # SambaDomainInput | 
  content_type: "application/json", # String | 
  accept: "application/json", # String | 
  x_org_id: "<<your org id>>" # String | 
}

begin
  #Update Samba Domain
  result = api_instance.ldapservers_samba_domains_put(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ldapserver_id** | **String**| Unique identifier of the LDAP server. | 
 **id** | **String**| Unique identifier of the samba domain. | 
 **body** | [**SambaDomainInput**](SambaDomainInput.md)|  | [optional] 
 **content_type** | **String**|  | [optional] [default to application/json]
 **accept** | **String**|  | [optional] [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to &lt;&lt;your org id&gt;&gt;]

### Return type

[**SambaDomainOutput**](SambaDomainOutput.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



