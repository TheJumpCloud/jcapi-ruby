# JCAPIv2::DuoApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**duo_account_get**](DuoApi.md#duo_account_get) | **GET** /duo/accounts/{id} | Get a Duo Acount
[**duo_account_list**](DuoApi.md#duo_account_list) | **GET** /duo/accounts | List Duo Acounts
[**duo_account_post**](DuoApi.md#duo_account_post) | **POST** /duo/accounts | Create Duo Account
[**duo_application_delete**](DuoApi.md#duo_application_delete) | **DELETE** /duo/accounts/{account_id}/applications/{application_id} | Delete a Duo Application
[**duo_application_get**](DuoApi.md#duo_application_get) | **GET** /duo/accounts/{account_id}/applications/{application_id} | Get a Duo application
[**duo_application_list**](DuoApi.md#duo_application_list) | **GET** /duo/accounts/{account_id}/applications | List Duo Applications
[**duo_application_post**](DuoApi.md#duo_application_post) | **POST** /duo/accounts/{account_id}/applications | Create Duo Application


# **duo_account_get**
> DuoAccount duo_account_get(id, content_type, accept, opts)

Get a Duo Acount

#### Sample Request ``` curl https://console.jumpcloud.com/api/v2/duo/accounts/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

id = "id_example" # String | ObjectID of the Duo Account

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Get a Duo Acount
  result = api_instance.duo_account_get(id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ObjectID of the Duo Account | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**DuoAccount**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_account_list**
> Array&lt;DuoAccount&gt; duo_account_list(x_api_key, content_type, , opts)

List Duo Acounts

#### Sample Request ``` curl https://console.jumpcloud.com/api/v2/duo/accounts \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

x_api_key = "x_api_key_example" # String | 

content_type = "application/json" # String | 

opts = { 
  accept: "accept_example", # String | 
  x_org_id: "x_org_id_example" # String | 
}

begin
  #List Duo Acounts
  result = api_instance.duo_account_list(x_api_key, content_type, , opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_api_key** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [optional] 
 **x_org_id** | **String**|  | [optional] 

### Return type

[**Array&lt;DuoAccount&gt;**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_account_post**
> DuoAccount duo_account_post(content_type, accept, opts)

Create Duo Account

Registers a Duo account for an organization. Only one Duo account will be allowed, in case an organization has a Duo account already a 409 (Conflict) code will be returned.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/duo/accounts \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"registrationApplication\": {       \"apiHost\": \"api-1234.duosecurity.com\",       \"integrationKey\": \"1234\",       \"secretKey\": \"5678\"     }   }' ```

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

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::DuoRegistrationApplicationReq.new, # DuoRegistrationApplicationReq | 
  x_org_id: "" # String | 
}

begin
  #Create Duo Account
  result = api_instance.duo_account_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**DuoRegistrationApplicationReq**](DuoRegistrationApplicationReq.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**DuoAccount**](DuoAccount.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_application_delete**
> DuoApplication duo_application_delete(account_id, application_id, content_type, accept, opts)

Delete a Duo Application

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::DuoApi.new

account_id = "account_id_example" # String | 

application_id = "application_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Delete a Duo Application
  result = api_instance.duo_application_delete(account_id, application_id, content_type, accept, opts)
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
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_application_get**
> DuoApplication duo_application_get(account_id, application_id, content_type, accept, opts)

Get a Duo application

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::DuoApi.new

account_id = "account_id_example" # String | 

application_id = "application_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Get a Duo application
  result = api_instance.duo_application_get(account_id, application_id, content_type, accept, opts)
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
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_application_list**
> Array&lt;DuoApplication&gt; duo_application_list(account_id, content_type, accept, opts)

List Duo Applications

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::DuoApi.new

account_id = "account_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #List Duo Applications
  result = api_instance.duo_application_list(account_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;DuoApplication&gt;**](DuoApplication.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **duo_application_post**
> DuoApplication duo_application_post(account_id, content_type, accept, opts)

Create Duo Application

Creates a Duo application for an organization and its account.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/duo/accounts/obj-id-123/applications \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Application Name\",     \"apiHost\": \"api-1234.duosecurity.com\",     \"integrationKey\": \"1234\",     \"secretKey\": \"5678\"   }' ```

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::DuoApi.new

account_id = "account_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::DuoApplicationReq.new, # DuoApplicationReq | 
  x_org_id: "" # String | 
}

begin
  #Create Duo Application
  result = api_instance.duo_application_post(account_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **account_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**DuoApplicationReq**](DuoApplicationReq.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**DuoApplication**](DuoApplication.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



