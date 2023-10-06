# JCAPIv2::ManagedServiceProviderApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**administrator_organizations_create_by_administrator**](ManagedServiceProviderApi.md#administrator_organizations_create_by_administrator) | **POST** /administrators/{id}/organizationlinks | Allow Adminstrator access to an Organization.
[**administrator_organizations_list_by_administrator**](ManagedServiceProviderApi.md#administrator_organizations_list_by_administrator) | **GET** /administrators/{id}/organizationlinks | List the association links between an Administrator and Organizations.
[**administrator_organizations_list_by_organization**](ManagedServiceProviderApi.md#administrator_organizations_list_by_organization) | **GET** /organizations/{id}/administratorlinks | List the association links between an Organization and Administrators.
[**administrator_organizations_remove_by_administrator**](ManagedServiceProviderApi.md#administrator_organizations_remove_by_administrator) | **DELETE** /administrators/{administrator_id}/organizationlinks/{id} | Remove association between an Administrator and an Organization.
[**policy_group_templates_delete**](ManagedServiceProviderApi.md#policy_group_templates_delete) | **DELETE** /providers/{provider_id}/policygrouptemplates/{id} | Deletes policy group template.
[**policy_group_templates_get**](ManagedServiceProviderApi.md#policy_group_templates_get) | **GET** /providers/{provider_id}/policygrouptemplates/{id} | Gets a provider&#x27;s policy group template.
[**policy_group_templates_get_configured_policy_template**](ManagedServiceProviderApi.md#policy_group_templates_get_configured_policy_template) | **GET** /providers/{provider_id}/configuredpolicytemplates/{id} | Retrieve a configured policy template by id.
[**policy_group_templates_list**](ManagedServiceProviderApi.md#policy_group_templates_list) | **GET** /providers/{provider_id}/policygrouptemplates | List a provider&#x27;s policy group templates.
[**policy_group_templates_list_configured_policy_templates**](ManagedServiceProviderApi.md#policy_group_templates_list_configured_policy_templates) | **GET** /providers/{provider_id}/configuredpolicytemplates | List a provider&#x27;s configured policy templates.
[**policy_group_templates_list_members**](ManagedServiceProviderApi.md#policy_group_templates_list_members) | **GET** /providers/{provider_id}/policygrouptemplates/{id}/members | Gets the list of members from a policy group template.
[**provider_organizations_create_org**](ManagedServiceProviderApi.md#provider_organizations_create_org) | **POST** /providers/{provider_id}/organizations | Create Provider Organization
[**provider_organizations_update_org**](ManagedServiceProviderApi.md#provider_organizations_update_org) | **PUT** /providers/{provider_id}/organizations/{id} | Update Provider Organization
[**providers_get_provider**](ManagedServiceProviderApi.md#providers_get_provider) | **GET** /providers/{provider_id} | Retrieve Provider
[**providers_list_administrators**](ManagedServiceProviderApi.md#providers_list_administrators) | **GET** /providers/{provider_id}/administrators | List Provider Administrators
[**providers_list_organizations**](ManagedServiceProviderApi.md#providers_list_organizations) | **GET** /providers/{provider_id}/organizations | List Provider Organizations
[**providers_post_admins**](ManagedServiceProviderApi.md#providers_post_admins) | **POST** /providers/{provider_id}/administrators | Create a new Provider Administrator
[**providers_provider_list_case**](ManagedServiceProviderApi.md#providers_provider_list_case) | **GET** /providers/{provider_id}/cases | Get all cases (Support/Feature requests) for provider
[**providers_retrieve_invoice**](ManagedServiceProviderApi.md#providers_retrieve_invoice) | **GET** /providers/{provider_id}/invoices/{ID} | Download a provider&#x27;s invoice.
[**providers_retrieve_invoices**](ManagedServiceProviderApi.md#providers_retrieve_invoices) | **GET** /providers/{provider_id}/invoices | List a provider&#x27;s invoices.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AdministratorOrganizationLinkReq.new # AdministratorOrganizationLinkReq | 
}

begin
  #Allow Adminstrator access to an Organization.
  result = api_instance.administrator_organizations_create_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_create_by_administrator: #{e}"
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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
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
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_list_by_administrator: #{e}"
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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
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
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_list_by_organization: #{e}"
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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
administrator_id = 'administrator_id_example' # String | 
id = 'id_example' # String | 


begin
  #Remove association between an Administrator and an Organization.
  api_instance.administrator_organizations_remove_by_administrator(administrator_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_remove_by_administrator: #{e}"
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



# **policy_group_templates_delete**
> policy_group_templates_delete(provider_id, id)

Deletes policy group template.

Deletes a Policy Group Template.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes policy group template.
  api_instance.policy_group_templates_delete(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_get**
> PolicyGroupTemplate policy_group_templates_get(provider_id, id)

Gets a provider's policy group template.

Retrieves a Policy Group Template for this provider.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a provider's policy group template.
  result = api_instance.policy_group_templates_get(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**PolicyGroupTemplate**](PolicyGroupTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_get_configured_policy_template**
> ConfiguredPolicyTemplate policy_group_templates_get_configured_policy_template(provider_id, id)

Retrieve a configured policy template by id.

Retrieves a Configured Policy Templates for this provider and Id.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Retrieve a configured policy template by id.
  result = api_instance.policy_group_templates_get_configured_policy_template(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_get_configured_policy_template: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

[**ConfiguredPolicyTemplate**](ConfiguredPolicyTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list**
> PolicyGroupTemplates policy_group_templates_list(provider_id, opts)

List a provider's policy group templates.

Retrieves a list of Policy Group Templates for this provider.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's policy group templates.
  result = api_instance.policy_group_templates_list(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**PolicyGroupTemplates**](PolicyGroupTemplates.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list_configured_policy_templates**
> InlineResponse20014 policy_group_templates_list_configured_policy_templates(provider_id, opts)

List a provider's configured policy templates.

Retrieves a list of Configured Policy Templates for this provider.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's configured policy templates.
  result = api_instance.policy_group_templates_list_configured_policy_templates(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list_configured_policy_templates: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**InlineResponse20014**](InlineResponse20014.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **policy_group_templates_list_members**
> PolicyGroupTemplateMembers policy_group_templates_list_members(provider_id, id, opts)

Gets the list of members from a policy group template.

Retrieves a Policy Group Template's Members.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Gets the list of members from a policy group template.
  result = api_instance.policy_group_templates_list_members(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**PolicyGroupTemplateMembers**](PolicyGroupTemplateMembers.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **provider_organizations_create_org**
> Organization provider_organizations_create_org(provider_id, opts)

Create Provider Organization

This endpoint creates a new organization under the provider

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::CreateOrganization.new # CreateOrganization | 
}

begin
  #Create Provider Organization
  result = api_instance.provider_organizations_create_org(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->provider_organizations_create_org: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **body** | [**CreateOrganization**](CreateOrganization.md)|  | [optional] 

### Return type

[**Organization**](Organization.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **provider_organizations_update_org**
> Organization provider_organizations_update_org(provider_idid, opts)

Update Provider Organization

This endpoint updates a provider's organization

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::Organization.new # Organization | 
}

begin
  #Update Provider Organization
  result = api_instance.provider_organizations_update_org(provider_idid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->provider_organizations_update_org: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 
 **body** | [**Organization**](Organization.md)|  | [optional] 

### Return type

[**Organization**](Organization.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **providers_get_provider**
> Provider providers_get_provider(provider_id, opts)

Retrieve Provider

This endpoint returns details about a provider

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'] # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
}

begin
  #Retrieve Provider
  result = api_instance.providers_get_provider(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_get_provider: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 

### Return type

[**Provider**](Provider.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **providers_list_administrators**
> InlineResponse20013 providers_list_administrators(provider_id, opts)

List Provider Administrators

This endpoint returns a list of the Administrators associated with the Provider. You must be associated with the provider to use this route.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Administrators
  result = api_instance.providers_list_administrators(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_list_administrators: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **sort_ignore_case** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse20013**](InlineResponse20013.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **providers_list_organizations**
> InlineResponse20015 providers_list_organizations(provider_id, opts)

List Provider Organizations

This endpoint returns a list of the Organizations associated with the Provider. You must be associated with the provider to use this route.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Organizations
  result = api_instance.providers_list_organizations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_list_organizations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **sort_ignore_case** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse20015**](InlineResponse20015.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **providers_post_admins**
> Administrator providers_post_admins(provider_id, opts)

Create a new Provider Administrator

This endpoint allows you to create a provider administrator. You must be associated with the provider to use this route. You must provide either `role` or `roleName`.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ProviderAdminReq.new # ProviderAdminReq | 
}

begin
  #Create a new Provider Administrator
  result = api_instance.providers_post_admins(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_post_admins: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **body** | [**ProviderAdminReq**](ProviderAdminReq.md)|  | [optional] 

### Return type

[**Administrator**](Administrator.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **providers_provider_list_case**
> CasesResponse providers_provider_list_case(provider_id, opts)

Get all cases (Support/Feature requests) for provider

This endpoint returns the cases (Support/Feature requests) for the provider

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Get all cases (Support/Feature requests) for provider
  result = api_instance.providers_provider_list_case(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_provider_list_case: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**CasesResponse**](CasesResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **providers_retrieve_invoice**
> String providers_retrieve_invoice(provider_id, id)

Download a provider's invoice.

Retrieves an invoice for this provider. You must be associated to the provider to use this endpoint.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Download a provider's invoice.
  result = api_instance.providers_retrieve_invoice(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_retrieve_invoice: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **id** | **String**|  | 

### Return type

**String**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/pdf



# **providers_retrieve_invoices**
> ProviderInvoiceResponse providers_retrieve_invoices(provider_id, opts)

List a provider's invoices.

Retrieves a list of invoices for this provider. You must be associated to the provider to use this endpoint.

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

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
}

begin
  #List a provider's invoices.
  result = api_instance.providers_retrieve_invoices(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_retrieve_invoices: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]

### Return type

[**ProviderInvoiceResponse**](ProviderInvoiceResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



