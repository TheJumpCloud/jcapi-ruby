# JCAPIv1::UsersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**admin_totpreset_begin**](UsersApi.md#admin_totpreset_begin) | **POST** /users/resettotp/{id} | Administrator TOTP Reset Initiation
[**users_put**](UsersApi.md#users_put) | **PUT** /users/{id} | Update a user
[**users_reactivate_get**](UsersApi.md#users_reactivate_get) | **GET** /users/reactivate/{id} | Administrator Password Reset Initiation

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

api_instance = JCAPIv1::UsersApi.new
id = 'id_example' # String | 


begin
  #Administrator TOTP Reset Initiation
  api_instance.admin_totpreset_begin(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling UsersApi->admin_totpreset_begin: #{e}"
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

api_instance = JCAPIv1::UsersApi.new
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
  puts "Exception when calling UsersApi->users_put: #{e}"
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

api_instance = JCAPIv1::UsersApi.new
id = 'id_example' # String | 


begin
  #Administrator Password Reset Initiation
  api_instance.users_reactivate_get(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling UsersApi->users_reactivate_get: #{e}"
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



