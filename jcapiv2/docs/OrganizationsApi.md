# JCAPIv2::OrganizationsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**administrator_organizations_create_by_administrator**](OrganizationsApi.md#administrator_organizations_create_by_administrator) | **POST** /administrators/{id}/organizationlinks | Allow Adminstrator access to an Organization.
[**administrator_organizations_list_by_administrator**](OrganizationsApi.md#administrator_organizations_list_by_administrator) | **GET** /administrators/{id}/organizationlinks | List the association links between an Administrator and Organizations.
[**administrator_organizations_list_by_organization**](OrganizationsApi.md#administrator_organizations_list_by_organization) | **GET** /organizations/{id}/administratorlinks | List the association links between an Organization and Administrators.
[**administrator_organizations_remove_by_administrator**](OrganizationsApi.md#administrator_organizations_remove_by_administrator) | **DELETE** /administrators/{administrator_id}/organizationlinks/{id} | Remove association between an Administrator and an Organization.
[**organizations_list_cases**](OrganizationsApi.md#organizations_list_cases) | **GET** /organizations/cases | Get all cases (Support/Feature requests) for organization

# **administrator_organizations_create_by_administrator**
> AdministratorOrganizationLink administrator_organizations_create_by_administrator(id, opts)

Allow Adminstrator access to an Organization.

This endpoint allows you to grant Administrator access to an Organization.

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

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AdministratorOrganizationLinkReq.new # AdministratorOrganizationLinkReq | 
}

begin
  #Allow Adminstrator access to an Organization.
  result = api_instance.administrator_organizations_create_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_create_by_administrator: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**AdministratorOrganizationLinkReq**](AdministratorOrganizationLinkReq.md)|  | [optional] 

### Return type

[**AdministratorOrganizationLink**](AdministratorOrganizationLink.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **administrator_organizations_list_by_administrator**
> Array&lt;AdministratorOrganizationLink&gt; administrator_organizations_list_by_administrator(id, opts)

List the association links between an Administrator and Organizations.

This endpoint returns the association links between an Administrator and Organizations.

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

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Administrator and Organizations.
  result = api_instance.administrator_organizations_list_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_list_by_administrator: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;AdministratorOrganizationLink&gt;**](AdministratorOrganizationLink.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **administrator_organizations_list_by_organization**
> Array&lt;AdministratorOrganizationLink&gt; administrator_organizations_list_by_organization(id, opts)

List the association links between an Organization and Administrators.

This endpoint returns the association links between an Organization and Administrators.

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

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Organization and Administrators.
  result = api_instance.administrator_organizations_list_by_organization(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_list_by_organization: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;AdministratorOrganizationLink&gt;**](AdministratorOrganizationLink.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **administrator_organizations_remove_by_administrator**
> administrator_organizations_remove_by_administrator(administrator_id, id)

Remove association between an Administrator and an Organization.

This endpoint removes the association link between an Administrator and an Organization.

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

api_instance = JCAPIv2::OrganizationsApi.new
administrator_id = 'administrator_id_example' # String | 
id = 'id_example' # String | 


begin
  #Remove association between an Administrator and an Organization.
  api_instance.administrator_organizations_remove_by_administrator(administrator_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_remove_by_administrator: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **administrator_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **organizations_list_cases**
> OrganizationCasesResponse organizations_list_cases(opts)

Get all cases (Support/Feature requests) for organization

This endpoint returns the cases (Support/Feature requests) for the organization

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

api_instance = JCAPIv2::OrganizationsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
}

begin
  #Get all cases (Support/Feature requests) for organization
  result = api_instance.organizations_list_cases(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->organizations_list_cases: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]

### Return type

[**OrganizationCasesResponse**](OrganizationCasesResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



