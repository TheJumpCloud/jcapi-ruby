# JCAPIv1::ManagedServiceProviderApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**admin_totpreset_begin**](ManagedServiceProviderApi.md#admin_totpreset_begin) | **POST** /users/resettotp/{id} | Administrator TOTP Reset Initiation
[**organization_list**](ManagedServiceProviderApi.md#organization_list) | **GET** /organizations | Get Organization Details
[**users_put**](ManagedServiceProviderApi.md#users_put) | **PUT** /users/{id} | Update a user
[**users_reactivate_get**](ManagedServiceProviderApi.md#users_reactivate_get) | **GET** /users/reactivate/{id} | Administrator Password Reset Initiation

# **admin_totpreset_begin**
> admin_totpreset_begin(id)

Administrator TOTP Reset Initiation

This endpoint initiates a TOTP reset for an admin. This request does not accept a body.

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

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 


begin
  #Administrator TOTP Reset Initiation
  api_instance.admin_totpreset_begin(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->admin_totpreset_begin: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **organization_list**
> Organizationslist organization_list(opts)

Get Organization Details

This endpoint returns Organization Details.  #### Sample Request  ``` curl -X GET \\   https://console.jumpcloud.com/api/organizations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

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

api_instance = JCAPIv1::ManagedServiceProviderApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  search: 'search_example', # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  sort_ignore_case: 'sort_ignore_case_example' # String | Use space separated sort parameters to sort the collection, ignoring case. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #Get Organization Details
  result = api_instance.organization_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->organization_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **search** | **String**| A nested object containing a &#x60;searchTerm&#x60; string or array of strings and a list of &#x60;fields&#x60; to search on. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **sort_ignore_case** | **String**| Use space separated sort parameters to sort the collection, ignoring case. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**Organizationslist**](Organizationslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **users_put**
> Userreturn users_put(id, opts)

Update a user

This endpoint allows you to update a user.

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

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Userput.new # Userput | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update a user
  result = api_instance.users_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->users_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**Userput**](Userput.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 

### Return type

[**Userreturn**](Userreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **users_reactivate_get**
> users_reactivate_get(id)

Administrator Password Reset Initiation

This endpoint triggers the sending of a reactivation e-mail to an administrator.

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

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 


begin
  #Administrator Password Reset Initiation
  api_instance.users_reactivate_get(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->users_reactivate_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



