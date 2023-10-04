# JCAPIv2::DuoApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**duo_account_delete**](DuoApi.md#duo_account_delete) | **DELETE** /duo/accounts/{id} | Delete a Duo Account
[**duo_account_get**](DuoApi.md#duo_account_get) | **GET** /duo/accounts/{id} | Get a Duo Acount
[**duo_account_list**](DuoApi.md#duo_account_list) | **GET** /duo/accounts | List Duo Accounts
[**duo_account_post**](DuoApi.md#duo_account_post) | **POST** /duo/accounts | Create Duo Account
[**duo_application_delete**](DuoApi.md#duo_application_delete) | **DELETE** /duo/accounts/{account_id}/applications/{application_id} | Delete a Duo Application
[**duo_application_get**](DuoApi.md#duo_application_get) | **GET** /duo/accounts/{account_id}/applications/{application_id} | Get a Duo application
[**duo_application_list**](DuoApi.md#duo_application_list) | **GET** /duo/accounts/{account_id}/applications | List Duo Applications
[**duo_application_post**](DuoApi.md#duo_application_post) | **POST** /duo/accounts/{account_id}/applications | Create Duo Application
[**duo_application_update**](DuoApi.md#duo_application_update) | **PUT** /duo/accounts/{account_id}/applications/{application_id} | Update Duo Application

# **duo_account_delete**
> DuoAccount duo_account_delete(id, opts)

Delete a Duo Account

Removes the specified Duo account, an error will be returned if the account has some Duo application used in a protected resource.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/duo/accounts/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::DuoApi.new
id = 'id_example' # String | ObjectID of the Duo Account
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Duo Account
  result = api_instance.duo_account_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Duo Account | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoAccount**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_account_get**
> DuoAccount duo_account_get(id, opts)

Get a Duo Acount

This endpoint returns a specific Duo account.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/duo/accounts/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::DuoApi.new
id = 'id_example' # String | ObjectID of the Duo Account
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a Duo Acount
  result = api_instance.duo_account_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Duo Account | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoAccount**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_account_list**
> Array&lt;DuoAccount&gt; duo_account_list(opts)

List Duo Accounts

This endpoint returns all the Duo accounts for your organization. Note: There can currently only be one Duo account for your organization.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/duo/accounts \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::DuoApi.new
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Duo Accounts
  result = api_instance.duo_account_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;DuoAccount&gt;**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_account_post**
> DuoAccount duo_account_post(opts)

Create Duo Account

Registers a Duo account for an organization. Only one Duo account will be allowed, in case an organization has a Duo account already a 409 (Conflict) code will be returned.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/duo/accounts \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::DuoApi.new
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Duo Account
  result = api_instance.duo_account_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoAccount**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_application_delete**
> DuoApplication duo_application_delete(account_id, application_id, opts)

Delete a Duo Application

Deletes the specified Duo application, an error will be returned if the application is used in a protected resource.  #### Sample Request ```   curl -X DELETE https://console.jumpcloud.com/api/v2/duo/accounts/{ACCOUNT_ID}/applications/{APPLICATION_ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}'' ```

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

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Duo Application
  result = api_instance.duo_application_delete(account_id, application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **application_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_application_get**
> DuoApplication duo_application_get(account_id, application_id, opts)

Get a Duo application

This endpoint returns a specific Duo application that is associated with the specified Duo account.  #### Sample Request ```   curl https://console.jumpcloud.com/api/v2/duo/accounts/{ACCOUNT_ID}/applications/{APPLICATION_ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a Duo application
  result = api_instance.duo_application_get(account_id, application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **application_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_application_list**
> Array&lt;DuoApplication&gt; duo_application_list(account_id, opts)

List Duo Applications

This endpoint returns all the Duo applications for the specified Duo account. Note: There can currently only be one Duo application for your organization.  #### Sample Request ```   curl https://console.jumpcloud.com/api/v2/duo/accounts/{ACCOUNT_ID}/applications \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Duo Applications
  result = api_instance.duo_application_list(account_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;DuoApplication&gt;**](DuoApplication.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **duo_application_post**
> DuoApplication duo_application_post(account_id, opts)

Create Duo Application

Creates a Duo application for your organization and the specified account.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/duo/accounts/{ACCOUNT_ID}/applications \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Application Name\",     \"apiHost\": \"api-1234.duosecurity.com\",     \"integrationKey\": \"1234\",     \"secretKey\": \"5678\"   }' ```

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

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
opts = { 
  body: JCAPIv2::DuoApplicationReq.new # DuoApplicationReq | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Duo Application
  result = api_instance.duo_application_post(account_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **body** | [**DuoApplicationReq**](DuoApplicationReq.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_application_update**
> DuoApplication duo_application_update(account_idapplication_id, opts)

Update Duo Application

Updates the specified Duo application.  #### Sample Request ```   curl -X PUT https://console.jumpcloud.com/api/v2/duo/accounts/{ACCOUNT_ID}/applications/{APPLICATION_ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Application Name\",     \"apiHost\": \"api-1234.duosecurity.com\",     \"integrationKey\": \"1234\",     \"secretKey\": \"5678\"   }' ```

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

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  body: JCAPIv2::DuoApplicationUpdateReq.new # DuoApplicationUpdateReq | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update Duo Application
  result = api_instance.duo_application_update(account_idapplication_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **application_id** | **String**|  | 
 **body** | [**DuoApplicationUpdateReq**](DuoApplicationUpdateReq.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



