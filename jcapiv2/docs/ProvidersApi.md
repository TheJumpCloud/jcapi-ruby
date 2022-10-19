# JCAPIv2::ProvidersApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**autotask_create_configuration**](ProvidersApi.md#autotask_create_configuration) | **POST** /providers/{provider_id}/integrations/autotask | Creates a new Autotask integration for the provider
[**autotask_delete_configuration**](ProvidersApi.md#autotask_delete_configuration) | **DELETE** /integrations/autotask/{UUID} | Delete Autotask Integration
[**autotask_get_configuration**](ProvidersApi.md#autotask_get_configuration) | **GET** /integrations/autotask/{UUID} | Retrieve Autotask Integration Configuration
[**autotask_patch_mappings**](ProvidersApi.md#autotask_patch_mappings) | **PATCH** /integrations/autotask/{UUID}/mappings | Create, edit, and/or delete Autotask Mappings
[**autotask_patch_settings**](ProvidersApi.md#autotask_patch_settings) | **PATCH** /integrations/autotask/{UUID}/settings | Create, edit, and/or delete Autotask Integration settings
[**autotask_retrieve_all_alert_configuration_options**](ProvidersApi.md#autotask_retrieve_all_alert_configuration_options) | **GET** /providers/{provider_id}/integrations/autotask/alerts/configuration/options | Get all Autotask ticketing alert configuration options for a provider
[**autotask_retrieve_all_alert_configurations**](ProvidersApi.md#autotask_retrieve_all_alert_configurations) | **GET** /providers/{provider_id}/integrations/autotask/alerts/configuration | Get all Autotask ticketing alert configurations for a provider
[**autotask_retrieve_companies**](ProvidersApi.md#autotask_retrieve_companies) | **GET** /integrations/autotask/{UUID}/companies | Retrieve Autotask Companies
[**autotask_retrieve_company_types**](ProvidersApi.md#autotask_retrieve_company_types) | **GET** /integrations/autotask/{UUID}/companytypes | Retrieve Autotask Company Types
[**autotask_retrieve_contracts**](ProvidersApi.md#autotask_retrieve_contracts) | **GET** /integrations/autotask/{UUID}/contracts | Retrieve Autotask Contracts
[**autotask_retrieve_contracts_fields**](ProvidersApi.md#autotask_retrieve_contracts_fields) | **GET** /integrations/autotask/{UUID}/contracts/fields | Retrieve Autotask Contract Fields
[**autotask_retrieve_mappings**](ProvidersApi.md#autotask_retrieve_mappings) | **GET** /integrations/autotask/{UUID}/mappings | Retrieve Autotask mappings
[**autotask_retrieve_services**](ProvidersApi.md#autotask_retrieve_services) | **GET** /integrations/autotask/{UUID}/contracts/services | Retrieve Autotask Contract Services
[**autotask_retrieve_settings**](ProvidersApi.md#autotask_retrieve_settings) | **GET** /integrations/autotask/{UUID}/settings | Retrieve Autotask Integration settings
[**autotask_update_alert_configuration**](ProvidersApi.md#autotask_update_alert_configuration) | **PUT** /providers/{provider_id}/integrations/autotask/alerts/{alert_UUID}/configuration | Update an Autotask ticketing alert&#x27;s configuration
[**autotask_update_configuration**](ProvidersApi.md#autotask_update_configuration) | **PATCH** /integrations/autotask/{UUID} | Update Autotask Integration configuration
[**connectwise_create_configuration**](ProvidersApi.md#connectwise_create_configuration) | **POST** /providers/{provider_id}/integrations/connectwise | Creates a new ConnectWise integration for the provider
[**connectwise_delete_configuration**](ProvidersApi.md#connectwise_delete_configuration) | **DELETE** /integrations/connectwise/{UUID} | Delete ConnectWise Integration
[**connectwise_get_configuration**](ProvidersApi.md#connectwise_get_configuration) | **GET** /integrations/connectwise/{UUID} | Retrieve ConnectWise Integration Configuration
[**connectwise_patch_mappings**](ProvidersApi.md#connectwise_patch_mappings) | **PATCH** /integrations/connectwise/{UUID}/mappings | Create, edit, and/or delete ConnectWise Mappings
[**connectwise_patch_settings**](ProvidersApi.md#connectwise_patch_settings) | **PATCH** /integrations/connectwise/{UUID}/settings | Create, edit, and/or delete ConnectWise Integration settings
[**connectwise_retrieve_additions**](ProvidersApi.md#connectwise_retrieve_additions) | **GET** /integrations/connectwise/{UUID}/agreements/{agreement_ID}/additions | Retrieve ConnectWise Additions
[**connectwise_retrieve_agreements**](ProvidersApi.md#connectwise_retrieve_agreements) | **GET** /integrations/connectwise/{UUID}/agreements | Retrieve ConnectWise Agreements
[**connectwise_retrieve_all_alert_configuration_options**](ProvidersApi.md#connectwise_retrieve_all_alert_configuration_options) | **GET** /providers/{provider_id}/integrations/connectwise/alerts/configuration/options | Get all ConnectWise ticketing alert configuration options for a provider
[**connectwise_retrieve_all_alert_configurations**](ProvidersApi.md#connectwise_retrieve_all_alert_configurations) | **GET** /providers/{provider_id}/integrations/connectwise/alerts/configuration | Get all ConnectWise ticketing alert configurations for a provider
[**connectwise_retrieve_companies**](ProvidersApi.md#connectwise_retrieve_companies) | **GET** /integrations/connectwise/{UUID}/companies | Retrieve ConnectWise Companies
[**connectwise_retrieve_company_types**](ProvidersApi.md#connectwise_retrieve_company_types) | **GET** /integrations/connectwise/{UUID}/companytypes | Retrieve ConnectWise Company Types
[**connectwise_retrieve_mappings**](ProvidersApi.md#connectwise_retrieve_mappings) | **GET** /integrations/connectwise/{UUID}/mappings | Retrieve ConnectWise mappings
[**connectwise_retrieve_settings**](ProvidersApi.md#connectwise_retrieve_settings) | **GET** /integrations/connectwise/{UUID}/settings | Retrieve ConnectWise Integration settings
[**connectwise_update_alert_configuration**](ProvidersApi.md#connectwise_update_alert_configuration) | **PUT** /providers/{provider_id}/integrations/connectwise/alerts/{alert_UUID}/configuration | Update a ConnectWise ticketing alert&#x27;s configuration
[**connectwise_update_configuration**](ProvidersApi.md#connectwise_update_configuration) | **PATCH** /integrations/connectwise/{UUID} | Update ConnectWise Integration configuration
[**mtp_integration_retrieve_alerts**](ProvidersApi.md#mtp_integration_retrieve_alerts) | **GET** /providers/{provider_id}/integrations/ticketing/alerts | Get all ticketing alerts available for a provider&#x27;s ticketing integration.
[**mtp_integration_retrieve_sync_errors**](ProvidersApi.md#mtp_integration_retrieve_sync_errors) | **GET** /integrations/{integration_type}/{UUID}/errors | Retrieve Recent Integration Sync Errors
[**provider_organizations_update_org**](ProvidersApi.md#provider_organizations_update_org) | **PUT** /providers/{provider_id}/organizations/{id} | Update Provider Organization
[**providers_get_provider**](ProvidersApi.md#providers_get_provider) | **GET** /providers/{provider_id} | Retrieve Provider
[**providers_list_administrators**](ProvidersApi.md#providers_list_administrators) | **GET** /providers/{provider_id}/administrators | List Provider Administrators
[**providers_list_organizations**](ProvidersApi.md#providers_list_organizations) | **GET** /providers/{provider_id}/organizations | List Provider Organizations
[**providers_post_admins**](ProvidersApi.md#providers_post_admins) | **POST** /providers/{provider_id}/administrators | Create a new Provider Administrator
[**providers_remove_administrator**](ProvidersApi.md#providers_remove_administrator) | **DELETE** /providers/{provider_id}/administrators/{id} | Delete Provider Administrator
[**providers_retrieve_integrations**](ProvidersApi.md#providers_retrieve_integrations) | **GET** /providers/{provider_id}/integrations | Retrieve Integrations for Provider
[**providers_retrieve_invoice**](ProvidersApi.md#providers_retrieve_invoice) | **GET** /providers/{provider_id}/invoices/{ID} | Download a provider&#x27;s invoice.
[**providers_retrieve_invoices**](ProvidersApi.md#providers_retrieve_invoices) | **GET** /providers/{provider_id}/invoices | List a provider&#x27;s invoices.

# **autotask_create_configuration**
> InlineResponse201 autotask_create_configuration(provider_id, opts)

Creates a new Autotask integration for the provider

Creates a new Autotask integration for the provider. You must be associated with the provider to use this route. A 422 Unprocessable Entity response means the server failed to validate with Autotask.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskIntegrationReq.new # AutotaskIntegrationReq | 
}

begin
  #Creates a new Autotask integration for the provider
  result = api_instance.autotask_create_configuration(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_create_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **body** | [**AutotaskIntegrationReq**](AutotaskIntegrationReq.md)|  | [optional] 

### Return type

[**InlineResponse201**](InlineResponse201.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **autotask_delete_configuration**
> autotask_delete_configuration(uuid)

Delete Autotask Integration

Removes a Autotask integration.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Delete Autotask Integration
  api_instance.autotask_delete_configuration(uuid)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_delete_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_get_configuration**
> AutotaskIntegration autotask_get_configuration(uuid)

Retrieve Autotask Integration Configuration

Retrieves configuration for given Autotask integration id. You must be associated to the provider the integration is tied to in order to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Integration Configuration
  result = api_instance.autotask_get_configuration(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_get_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**AutotaskIntegration**](AutotaskIntegration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_patch_mappings**
> AutotaskMappingResponse autotask_patch_mappings(uuid, opts)

Create, edit, and/or delete Autotask Mappings

Create, edit, and/or delete mappings between Jumpcloud organizations and Autotask companies/contracts/services. You must be associated to the same provider as the Autotask integration to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskMappingRequest.new # AutotaskMappingRequest | 
}

begin
  #Create, edit, and/or delete Autotask Mappings
  result = api_instance.autotask_patch_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_patch_mappings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**AutotaskMappingRequest**](AutotaskMappingRequest.md)|  | [optional] 

### Return type

[**AutotaskMappingResponse**](AutotaskMappingResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **autotask_patch_settings**
> AutotaskSettings autotask_patch_settings(uuid, opts)

Create, edit, and/or delete Autotask Integration settings

Create, edit, and/or delete Autotask settings. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskSettingsPatchReq.new # AutotaskSettingsPatchReq | 
}

begin
  #Create, edit, and/or delete Autotask Integration settings
  result = api_instance.autotask_patch_settings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_patch_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**AutotaskSettingsPatchReq**](AutotaskSettingsPatchReq.md)|  | [optional] 

### Return type

[**AutotaskSettings**](AutotaskSettings.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **autotask_retrieve_all_alert_configuration_options**
> AutotaskTicketingAlertConfigurationOptions autotask_retrieve_all_alert_configuration_options(provider_id)

Get all Autotask ticketing alert configuration options for a provider

Get all Autotask ticketing alert configuration options for a provider.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Autotask ticketing alert configuration options for a provider
  result = api_instance.autotask_retrieve_all_alert_configuration_options(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_all_alert_configuration_options: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 

### Return type

[**AutotaskTicketingAlertConfigurationOptions**](AutotaskTicketingAlertConfigurationOptions.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_all_alert_configurations**
> AutotaskTicketingAlertConfigurationList autotask_retrieve_all_alert_configurations(provider_id)

Get all Autotask ticketing alert configurations for a provider

Get all Autotask ticketing alert configurations for a provider.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Autotask ticketing alert configurations for a provider
  result = api_instance.autotask_retrieve_all_alert_configurations(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_all_alert_configurations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 

### Return type

[**AutotaskTicketingAlertConfigurationList**](AutotaskTicketingAlertConfigurationList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_companies**
> AutotaskCompanyResp autotask_retrieve_companies(uuid, opts)

Retrieve Autotask Companies

Retrieves a list of Autotask companies for the given Autotask id. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Companies
  result = api_instance.autotask_retrieve_companies(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_companies: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**AutotaskCompanyResp**](AutotaskCompanyResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_company_types**
> AutotaskCompanyTypeResp autotask_retrieve_company_types(uuid)

Retrieve Autotask Company Types

Retrieves a list of user defined company types from Autotask for the given Autotask id.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Company Types
  result = api_instance.autotask_retrieve_company_types(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_company_types: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**AutotaskCompanyTypeResp**](AutotaskCompanyTypeResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_contracts**
> InlineResponse2003 autotask_retrieve_contracts(uuid, opts)

Retrieve Autotask Contracts

Retrieves a list of Autotask contracts for the given Autotask integration id. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Contracts
  result = api_instance.autotask_retrieve_contracts(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_contracts: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2003**](InlineResponse2003.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_contracts_fields**
> InlineResponse2004 autotask_retrieve_contracts_fields(uuid)

Retrieve Autotask Contract Fields

Retrieves a list of Autotask contract fields for the given Autotask integration id. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Contract Fields
  result = api_instance.autotask_retrieve_contracts_fields(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_contracts_fields: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**InlineResponse2004**](InlineResponse2004.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_mappings**
> InlineResponse2006 autotask_retrieve_mappings(uuid, opts)

Retrieve Autotask mappings

Retrieves the list of mappings for this Autotask integration. You must be associated to the same provider as the Autotask integration to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask mappings
  result = api_instance.autotask_retrieve_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_mappings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2006**](InlineResponse2006.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_services**
> InlineResponse2005 autotask_retrieve_services(uuid, opts)

Retrieve Autotask Contract Services

Retrieves a list of Autotask contract services for the given Autotask integration id. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Contract Services
  result = api_instance.autotask_retrieve_services(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2005**](InlineResponse2005.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_retrieve_settings**
> AutotaskSettings autotask_retrieve_settings(uuid)

Retrieve Autotask Integration settings

Retrieve the Autotask integration settings. You must be associated to the same provider as the Autotask integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Integration settings
  result = api_instance.autotask_retrieve_settings(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**AutotaskSettings**](AutotaskSettings.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **autotask_update_alert_configuration**
> AutotaskTicketingAlertConfiguration autotask_update_alert_configuration(provider_idalert_uuid, opts)

Update an Autotask ticketing alert's configuration

Update an Autotask ticketing alert's configuration

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
alert_uuid = 'alert_uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskTicketingAlertConfigurationRequest.new # AutotaskTicketingAlertConfigurationRequest | 
}

begin
  #Update an Autotask ticketing alert's configuration
  result = api_instance.autotask_update_alert_configuration(provider_idalert_uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_update_alert_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **alert_uuid** | **String**|  | 
 **body** | [**AutotaskTicketingAlertConfigurationRequest**](AutotaskTicketingAlertConfigurationRequest.md)|  | [optional] 

### Return type

[**AutotaskTicketingAlertConfiguration**](AutotaskTicketingAlertConfiguration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **autotask_update_configuration**
> AutotaskIntegration autotask_update_configuration(uuid, opts)

Update Autotask Integration configuration

Update the Autotask integration configuration. A 422 Unprocessable Entity response means the server failed to validate with Autotask.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskIntegrationPatchReq.new # AutotaskIntegrationPatchReq | 
}

begin
  #Update Autotask Integration configuration
  result = api_instance.autotask_update_configuration(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_update_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**AutotaskIntegrationPatchReq**](AutotaskIntegrationPatchReq.md)|  | [optional] 

### Return type

[**AutotaskIntegration**](AutotaskIntegration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **connectwise_create_configuration**
> InlineResponse201 connectwise_create_configuration(provider_id, opts)

Creates a new ConnectWise integration for the provider

Creates a new ConnectWise integration for the provider. You must be associated with the provider to use this route. A 422 Unprocessable Entity response means the server failed to validate with ConnectWise.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ConnectwiseIntegrationReq.new # ConnectwiseIntegrationReq | 
}

begin
  #Creates a new ConnectWise integration for the provider
  result = api_instance.connectwise_create_configuration(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_create_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **body** | [**ConnectwiseIntegrationReq**](ConnectwiseIntegrationReq.md)|  | [optional] 

### Return type

[**InlineResponse201**](InlineResponse201.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **connectwise_delete_configuration**
> connectwise_delete_configuration(uuid)

Delete ConnectWise Integration

Removes a ConnectWise integration.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Delete ConnectWise Integration
  api_instance.connectwise_delete_configuration(uuid)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_delete_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_get_configuration**
> ConnectwiseIntegration connectwise_get_configuration(uuid)

Retrieve ConnectWise Integration Configuration

Retrieves configuration for given ConnectWise integration id. You must be associated to the provider the integration is tied to in order to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Integration Configuration
  result = api_instance.connectwise_get_configuration(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_get_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**ConnectwiseIntegration**](ConnectwiseIntegration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_patch_mappings**
> ConnectWiseMappingRequest connectwise_patch_mappings(uuid, opts)

Create, edit, and/or delete ConnectWise Mappings

Create, edit, and/or delete mappings between Jumpcloud organizations and ConnectWise companies/agreements/additions. You must be associated to the same provider as the ConnectWise integration to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseMappingRequest.new # ConnectWiseMappingRequest | 
}

begin
  #Create, edit, and/or delete ConnectWise Mappings
  result = api_instance.connectwise_patch_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_patch_mappings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**ConnectWiseMappingRequest**](ConnectWiseMappingRequest.md)|  | [optional] 

### Return type

[**ConnectWiseMappingRequest**](ConnectWiseMappingRequest.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **connectwise_patch_settings**
> ConnectWiseSettings connectwise_patch_settings(uuid, opts)

Create, edit, and/or delete ConnectWise Integration settings

Create, edit, and/or delete ConnectWiseIntegration settings. You must be associated to the same provider as the ConnectWise integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseSettingsPatchReq.new # ConnectWiseSettingsPatchReq | 
}

begin
  #Create, edit, and/or delete ConnectWise Integration settings
  result = api_instance.connectwise_patch_settings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_patch_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**ConnectWiseSettingsPatchReq**](ConnectWiseSettingsPatchReq.md)|  | [optional] 

### Return type

[**ConnectWiseSettings**](ConnectWiseSettings.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **connectwise_retrieve_additions**
> InlineResponse2008 connectwise_retrieve_additions(uuid, agreement_id, opts)

Retrieve ConnectWise Additions

Retrieves a list of ConnectWise additions for the given ConnectWise id and Agreement id. You must be associated to the same provider as the ConnectWise integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
agreement_id = 'agreement_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Additions
  result = api_instance.connectwise_retrieve_additions(uuid, agreement_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_additions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **agreement_id** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2008**](InlineResponse2008.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_agreements**
> InlineResponse2007 connectwise_retrieve_agreements(uuid, opts)

Retrieve ConnectWise Agreements

Retrieves a list of ConnectWise agreements for the given ConnectWise id. You must be associated to the same provider as the ConnectWise integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Agreements
  result = api_instance.connectwise_retrieve_agreements(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_agreements: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2007**](InlineResponse2007.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_all_alert_configuration_options**
> ConnectWiseTicketingAlertConfigurationOptions connectwise_retrieve_all_alert_configuration_options(provider_id)

Get all ConnectWise ticketing alert configuration options for a provider

Get all ConnectWise ticketing alert configuration options for a provider.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ConnectWise ticketing alert configuration options for a provider
  result = api_instance.connectwise_retrieve_all_alert_configuration_options(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_all_alert_configuration_options: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 

### Return type

[**ConnectWiseTicketingAlertConfigurationOptions**](ConnectWiseTicketingAlertConfigurationOptions.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_all_alert_configurations**
> ConnectWiseTicketingAlertConfigurationList connectwise_retrieve_all_alert_configurations(provider_id)

Get all ConnectWise ticketing alert configurations for a provider

Get all ConnectWise ticketing alert configurations for a provider.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ConnectWise ticketing alert configurations for a provider
  result = api_instance.connectwise_retrieve_all_alert_configurations(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_all_alert_configurations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 

### Return type

[**ConnectWiseTicketingAlertConfigurationList**](ConnectWiseTicketingAlertConfigurationList.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_companies**
> ConnectwiseCompanyResp connectwise_retrieve_companies(uuid, opts)

Retrieve ConnectWise Companies

Retrieves a list of ConnectWise companies for the given ConnectWise id. You must be associated to the same provider as the ConnectWise integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Companies
  result = api_instance.connectwise_retrieve_companies(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_companies: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**ConnectwiseCompanyResp**](ConnectwiseCompanyResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_company_types**
> ConnectwiseCompanyTypeResp connectwise_retrieve_company_types(uuid)

Retrieve ConnectWise Company Types

Retrieves a list of user defined company types from ConnectWise for the given ConnectWise id.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Company Types
  result = api_instance.connectwise_retrieve_company_types(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_company_types: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**ConnectwiseCompanyTypeResp**](ConnectwiseCompanyTypeResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_mappings**
> InlineResponse2009 connectwise_retrieve_mappings(uuid, opts)

Retrieve ConnectWise mappings

Retrieves the list of mappings for this ConnectWise integration. You must be associated to the same provider as the ConnectWise integration to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise mappings
  result = api_instance.connectwise_retrieve_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_mappings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **fields** | [**Array&lt;String&gt;**](String.md)| The comma separated fields included in the returned records. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**InlineResponse2009**](InlineResponse2009.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_retrieve_settings**
> ConnectWiseSettings connectwise_retrieve_settings(uuid)

Retrieve ConnectWise Integration settings

Retrieve the ConnectWise integration settings. You must be associated to the same provider as the ConnectWise integration to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Integration settings
  result = api_instance.connectwise_retrieve_settings(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**ConnectWiseSettings**](ConnectWiseSettings.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **connectwise_update_alert_configuration**
> ConnectWiseTicketingAlertConfiguration connectwise_update_alert_configuration(provider_idalert_uuid, opts)

Update a ConnectWise ticketing alert's configuration

Update a ConnectWise ticketing alert's configuration.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
alert_uuid = 'alert_uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseTicketingAlertConfigurationRequest.new # ConnectWiseTicketingAlertConfigurationRequest | 
}

begin
  #Update a ConnectWise ticketing alert's configuration
  result = api_instance.connectwise_update_alert_configuration(provider_idalert_uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_update_alert_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **alert_uuid** | **String**|  | 
 **body** | [**ConnectWiseTicketingAlertConfigurationRequest**](ConnectWiseTicketingAlertConfigurationRequest.md)|  | [optional] 

### Return type

[**ConnectWiseTicketingAlertConfiguration**](ConnectWiseTicketingAlertConfiguration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **connectwise_update_configuration**
> ConnectwiseIntegration connectwise_update_configuration(uuid, opts)

Update ConnectWise Integration configuration

Update the ConnectWise integration configuration. A 422 Unprocessable Entity response means the server failed to validate with ConnectWise.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectwiseIntegrationPatchReq.new # ConnectwiseIntegrationPatchReq | 
}

begin
  #Update ConnectWise Integration configuration
  result = api_instance.connectwise_update_configuration(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_update_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **body** | [**ConnectwiseIntegrationPatchReq**](ConnectwiseIntegrationPatchReq.md)|  | [optional] 

### Return type

[**ConnectwiseIntegration**](ConnectwiseIntegration.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **mtp_integration_retrieve_alerts**
> TicketingIntegrationAlertsResp mtp_integration_retrieve_alerts(provider_id)

Get all ticketing alerts available for a provider's ticketing integration.

Get all ticketing alerts available for a provider's ticketing integration.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ticketing alerts available for a provider's ticketing integration.
  result = api_instance.mtp_integration_retrieve_alerts(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->mtp_integration_retrieve_alerts: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 

### Return type

[**TicketingIntegrationAlertsResp**](TicketingIntegrationAlertsResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **mtp_integration_retrieve_sync_errors**
> IntegrationSyncErrorResp mtp_integration_retrieve_sync_errors(uuid, integration_type)

Retrieve Recent Integration Sync Errors

Retrieves recent sync errors for given integration type and integration id. You must be associated to the provider the integration is tied to in order to use this api.

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

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
integration_type = 'integration_type_example' # String | 


begin
  #Retrieve Recent Integration Sync Errors
  result = api_instance.mtp_integration_retrieve_sync_errors(uuid, integration_type)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->mtp_integration_retrieve_sync_errors: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 
 **integration_type** | **String**|  | 

### Return type

[**IntegrationSyncErrorResp**](IntegrationSyncErrorResp.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
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

api_instance = JCAPIv2::ProvidersApi.new
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
  puts "Exception when calling ProvidersApi->provider_organizations_update_org: #{e}"
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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'] # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
}

begin
  #Retrieve Provider
  result = api_instance.providers_get_provider(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_get_provider: #{e}"
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
> InlineResponse20012 providers_list_administrators(provider_id, opts)

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Administrators
  result = api_instance.providers_list_administrators(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_list_administrators: #{e}"
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

### Return type

[**InlineResponse20012**](InlineResponse20012.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **providers_list_organizations**
> InlineResponse20013 providers_list_organizations(provider_id, opts)

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Organizations
  result = api_instance.providers_list_organizations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_list_organizations: #{e}"
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

### Return type

[**InlineResponse20013**](InlineResponse20013.md)

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ProviderAdminReq.new # ProviderAdminReq | 
}

begin
  #Create a new Provider Administrator
  result = api_instance.providers_post_admins(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_post_admins: #{e}"
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



# **providers_remove_administrator**
> providers_remove_administrator(provider_id, id)

Delete Provider Administrator

This endpoint removes an Administrator associated with the Provider. You must be associated with the provider to use this route.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Delete Provider Administrator
  api_instance.providers_remove_administrator(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_remove_administrator: #{e}"
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



# **providers_retrieve_integrations**
> IntegrationsResponse providers_retrieve_integrations(provider_id, opts)

Retrieve Integrations for Provider

Retrieves a list of integrations this provider has configured. You must be associated to the provider to use this endpoint.

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Integrations for Provider
  result = api_instance.providers_retrieve_integrations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_retrieve_integrations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **provider_id** | **String**|  | 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 

### Return type

[**IntegrationsResponse**](IntegrationsResponse.md)

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

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Download a provider's invoice.
  result = api_instance.providers_retrieve_invoice(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_retrieve_invoice: #{e}"
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

api_instance = JCAPIv2::ProvidersApi.new
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
  puts "Exception when calling ProvidersApi->providers_retrieve_invoices: #{e}"
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



