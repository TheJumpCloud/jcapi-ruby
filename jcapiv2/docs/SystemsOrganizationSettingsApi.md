# JCAPIv2::SystemsOrganizationSettingsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**systems_org_settings_get_sign_in_with_jump_cloud_settings**](SystemsOrganizationSettingsApi.md#systems_org_settings_get_sign_in_with_jump_cloud_settings) | **GET** /devices/settings/signinwithjumpcloud | Get the Sign In with JumpCloud Settings
[**systems_org_settings_set_sign_in_with_jump_cloud_settings**](SystemsOrganizationSettingsApi.md#systems_org_settings_set_sign_in_with_jump_cloud_settings) | **PUT** /devices/settings/signinwithjumpcloud | Set the Sign In with JumpCloud Settings

# **systems_org_settings_get_sign_in_with_jump_cloud_settings**
> DevicesGetSignInWithJumpCloudSettingsResponse systems_org_settings_get_sign_in_with_jump_cloud_settings(opts)

Get the Sign In with JumpCloud Settings

Gets the Sign In with JumpCloud Settings for an Organization.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/devices/settings/signinwithjumpcloud \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key:{API_KEY}' ```

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

api_instance = JCAPIv2::SystemsOrganizationSettingsApi.new
opts = { 
  organization_object_id: 'B' # String | 
}

begin
  #Get the Sign In with JumpCloud Settings
  result = api_instance.systems_org_settings_get_sign_in_with_jump_cloud_settings(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsOrganizationSettingsApi->systems_org_settings_get_sign_in_with_jump_cloud_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organization_object_id** | **String**|  | [optional] 

### Return type

[**DevicesGetSignInWithJumpCloudSettingsResponse**](DevicesGetSignInWithJumpCloudSettingsResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **systems_org_settings_set_sign_in_with_jump_cloud_settings**
> Object systems_org_settings_set_sign_in_with_jump_cloud_settings(body)

Set the Sign In with JumpCloud Settings

Sets the Sign In with JumpCloud Settings for an Organization.  #### Sample Request ``` curl -X PUT https://console.jumpcloud.com/api/v2/devices/settings/signinwithjumpcloud \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key:{API_KEY}' \\   -d '{\"settings\":[{\"osFamily\":\"WINDOWS\",\"enabled\":true,\"defaultPermission\":\"STANDARD\"}]}' ```

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

api_instance = JCAPIv2::SystemsOrganizationSettingsApi.new
body = JCAPIv2::DevicesSetSignInWithJumpCloudSettingsRequest.new # DevicesSetSignInWithJumpCloudSettingsRequest | 


begin
  #Set the Sign In with JumpCloud Settings
  result = api_instance.systems_org_settings_set_sign_in_with_jump_cloud_settings(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsOrganizationSettingsApi->systems_org_settings_set_sign_in_with_jump_cloud_settings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**DevicesSetSignInWithJumpCloudSettingsRequest**](DevicesSetSignInWithJumpCloudSettingsRequest.md)|  | 

### Return type

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



