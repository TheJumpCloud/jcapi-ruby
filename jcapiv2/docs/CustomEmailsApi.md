# JCAPIv2::CustomEmailsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**custom_emails_create**](CustomEmailsApi.md#custom_emails_create) | **POST** /customemails | Create custom email configuration
[**custom_emails_destroy**](CustomEmailsApi.md#custom_emails_destroy) | **DELETE** /customemails/{custom_email_type} | Delete custom email configuration
[**custom_emails_get_templates**](CustomEmailsApi.md#custom_emails_get_templates) | **GET** /customemail/templates | List custom email templates
[**custom_emails_read**](CustomEmailsApi.md#custom_emails_read) | **GET** /customemails/{custom_email_type} | Get custom email configuration
[**custom_emails_update**](CustomEmailsApi.md#custom_emails_update) | **PUT** /customemails/{custom_email_type} | Update custom email configuration

# **custom_emails_create**
> CustomEmail custom_emails_create(opts)

Create custom email configuration

Create the custom email configuration for the specified custom email type.  This action is only available to paying customers.

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

api_instance = JCAPIv2::CustomEmailsApi.new
opts = { 
  body: JCAPIv2::CustomEmail.new # CustomEmail | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create custom email configuration
  result = api_instance.custom_emails_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_create: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**CustomEmail**](CustomEmail.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**CustomEmail**](CustomEmail.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **custom_emails_destroy**
> custom_emails_destroy(custom_email_type, opts)

Delete custom email configuration

Delete the custom email configuration for the specified custom email type

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

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete custom email configuration
  api_instance.custom_emails_destroy(custom_email_type, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_destroy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **custom_email_type** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **custom_emails_get_templates**
> Array&lt;CustomEmailTemplate&gt; custom_emails_get_templates

List custom email templates

Get the list of custom email templates

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

api_instance = JCAPIv2::CustomEmailsApi.new

begin
  #List custom email templates
  result = api_instance.custom_emails_get_templates
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_get_templates: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;CustomEmailTemplate&gt;**](CustomEmailTemplate.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **custom_emails_read**
> CustomEmail custom_emails_read(custom_email_type, opts)

Get custom email configuration

Get the custom email configuration for the specified custom email type

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

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get custom email configuration
  result = api_instance.custom_emails_read(custom_email_type, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_read: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **custom_email_type** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**CustomEmail**](CustomEmail.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **custom_emails_update**
> CustomEmail custom_emails_update(custom_email_type, opts)

Update custom email configuration

Update the custom email configuration for the specified custom email type.  This action is only available to paying customers.

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

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  body: JCAPIv2::CustomEmail.new # CustomEmail | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update custom email configuration
  result = api_instance.custom_emails_update(custom_email_type, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **custom_email_type** | **String**|  | 
 **body** | [**CustomEmail**](CustomEmail.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**CustomEmail**](CustomEmail.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



