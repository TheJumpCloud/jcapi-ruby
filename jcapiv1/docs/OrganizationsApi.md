# JCAPIv1::OrganizationsApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**organization_list**](OrganizationsApi.md#organization_list) | **GET** /organizations | Get Organization Details
[**organization_put**](OrganizationsApi.md#organization_put) | **PUT** /organizations/{id} | Update an Organization
[**organizations_get**](OrganizationsApi.md#organizations_get) | **GET** /organizations/{id} | Get an Organization

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

api_instance = JCAPIv1::OrganizationsApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  search: 'search_example', # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example' # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #Get Organization Details
  result = api_instance.organization_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_list: #{e}"
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

### Return type

[**Organizationslist**](Organizationslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **organization_put**
> Organization organization_put(id, opts)

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
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::OrganizationsIdBody.new # OrganizationsIdBody | 
}

begin
  #Update an Organization
  result = api_instance.organization_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**OrganizationsIdBody**](OrganizationsIdBody.md)|  | [optional] 

### Return type

[**Organization**](Organization.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **organizations_get**
> Organization organizations_get(id, opts)

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
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
}

begin
  #Get an Organization
  result = api_instance.organizations_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organizations_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 

### Return type

[**Organization**](Organization.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



