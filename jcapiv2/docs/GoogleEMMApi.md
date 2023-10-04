# JCAPIv2::GoogleEMMApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**devices_erase_device**](GoogleEMMApi.md#devices_erase_device) | **POST** /google-emm/devices/{deviceId}/erase-device | Erase the Android Device
[**devices_get_device**](GoogleEMMApi.md#devices_get_device) | **GET** /google-emm/devices/{deviceId} | Get device
[**devices_get_device_android_policy**](GoogleEMMApi.md#devices_get_device_android_policy) | **GET** /google-emm/devices/{deviceId}/policy_results | Get the policy JSON of a device
[**devices_list_devices**](GoogleEMMApi.md#devices_list_devices) | **GET** /google-emm/enterprises/{enterpriseObjectId}/devices | List devices
[**devices_lock_device**](GoogleEMMApi.md#devices_lock_device) | **POST** /google-emm/devices/{deviceId}/lock | Lock device
[**devices_reboot_device**](GoogleEMMApi.md#devices_reboot_device) | **POST** /google-emm/devices/{deviceId}/reboot | Reboot device
[**devices_reset_password**](GoogleEMMApi.md#devices_reset_password) | **POST** /google-emm/devices/{deviceId}/resetpassword | Reset Password of a device
[**enrollment_tokens_create_enrollment_token**](GoogleEMMApi.md#enrollment_tokens_create_enrollment_token) | **POST** /google-emm/enrollment-tokens | Create an enrollment token
[**enterprises_create_enterprise**](GoogleEMMApi.md#enterprises_create_enterprise) | **POST** /google-emm/enterprises | Create a Google Enterprise
[**enterprises_delete_enterprise**](GoogleEMMApi.md#enterprises_delete_enterprise) | **DELETE** /google-emm/enterprises/{enterpriseId} | Delete a Google Enterprise
[**enterprises_get_connection_status**](GoogleEMMApi.md#enterprises_get_connection_status) | **GET** /google-emm/enterprises/{enterpriseId}/connection-status | Test connection with Google
[**enterprises_list_enterprises**](GoogleEMMApi.md#enterprises_list_enterprises) | **GET** /google-emm/enterprises | List Google Enterprises
[**enterprises_patch_enterprise**](GoogleEMMApi.md#enterprises_patch_enterprise) | **PATCH** /google-emm/enterprises/{enterpriseId} | Update a Google Enterprise
[**signup_urls_create**](GoogleEMMApi.md#signup_urls_create) | **POST** /google-emm/signup-urls | Get a Signup URL to enroll Google enterprise
[**web_tokens_create_web_token**](GoogleEMMApi.md#web_tokens_create_web_token) | **POST** /google-emm/web-tokens | Get a web token to render Google Play iFrame

# **devices_erase_device**
> JumpcloudGoogleEmmCommandResponse devices_erase_device(bodydevice_id)

Erase the Android Device

Removes the work profile and all policies from a personal/company-owned Android 8.0+ device. Company owned devices will be relinquished for personal use. Apps and data associated with the personal profile(s) are preserved.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/erase-device \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Erase the Android Device
  result = api_instance.devices_erase_device(bodydevice_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_erase_device: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Object**](Object.md)|  | 
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmCommandResponse**](JumpcloudGoogleEmmCommandResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **devices_get_device**
> JumpcloudGoogleEmmDevice devices_get_device(device_id)

Get device

Gets a Google EMM enrolled device details.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
device_id = 'B' # String | 


begin
  #Get device
  result = api_instance.devices_get_device(device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_get_device: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmDevice**](JumpcloudGoogleEmmDevice.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **devices_get_device_android_policy**
> JumpcloudGoogleEmmDeviceAndroidPolicy devices_get_device_android_policy(device_id)

Get the policy JSON of a device

Gets an android JSON policy for a Google EMM enrolled device.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/policy_results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
device_id = 'B' # String | 


begin
  #Get the policy JSON of a device
  result = api_instance.devices_get_device_android_policy(device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_get_device_android_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmDeviceAndroidPolicy**](JumpcloudGoogleEmmDeviceAndroidPolicy.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **devices_list_devices**
> JumpcloudGoogleEmmListDevicesResponse devices_list_devices(enterprise_object_id, opts)

List devices

Lists google EMM enrolled devices.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises/{enterprise_object_id}/devices \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_object_id = 'B' # String | 
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0', # String | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | 
}

begin
  #List devices
  result = api_instance.devices_list_devices(enterprise_object_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_list_devices: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enterprise_object_id** | **String**|  | 
 **limit** | **String**| The number of records to return at once. Limited to 100. | [optional] [default to 100]
 **skip** | **String**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)|  | [optional] 

### Return type

[**JumpcloudGoogleEmmListDevicesResponse**](JumpcloudGoogleEmmListDevicesResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **devices_lock_device**
> JumpcloudGoogleEmmCommandResponse devices_lock_device(bodydevice_id)

Lock device

Locks a Google EMM enrolled device, as if the lock screen timeout had expired.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/lock \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Lock device
  result = api_instance.devices_lock_device(bodydevice_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_lock_device: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Object**](Object.md)|  | 
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmCommandResponse**](JumpcloudGoogleEmmCommandResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **devices_reboot_device**
> JumpcloudGoogleEmmCommandResponse devices_reboot_device(bodydevice_id)

Reboot device

Reboots a Google EMM enrolled device. Only supported on fully managed devices running Android 7.0 or higher.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/reboot \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Reboot device
  result = api_instance.devices_reboot_device(bodydevice_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_reboot_device: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Object**](Object.md)|  | 
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmCommandResponse**](JumpcloudGoogleEmmCommandResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **devices_reset_password**
> JumpcloudGoogleEmmCommandResponse devices_reset_password(bodydevice_id)

Reset Password of a device

Reset the user's password of a Google EMM enrolled device.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/resetpassword \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'new_password' : 'string' }' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::DeviceIdResetpasswordBody.new # DeviceIdResetpasswordBody | 
device_id = 'B' # String | 


begin
  #Reset Password of a device
  result = api_instance.devices_reset_password(bodydevice_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_reset_password: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**DeviceIdResetpasswordBody**](DeviceIdResetpasswordBody.md)|  | 
 **device_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmCommandResponse**](JumpcloudGoogleEmmCommandResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **enrollment_tokens_create_enrollment_token**
> JumpcloudGoogleEmmCreateEnrollmentTokenResponse enrollment_tokens_create_enrollment_token(body)

Create an enrollment token

Gets an enrollment token to enroll a device into Google EMM.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enrollment-tokens \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateEnrollmentTokenRequest.new # JumpcloudGoogleEmmCreateEnrollmentTokenRequest | 


begin
  #Create an enrollment token
  result = api_instance.enrollment_tokens_create_enrollment_token(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enrollment_tokens_create_enrollment_token: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**JumpcloudGoogleEmmCreateEnrollmentTokenRequest**](JumpcloudGoogleEmmCreateEnrollmentTokenRequest.md)|  | 

### Return type

[**JumpcloudGoogleEmmCreateEnrollmentTokenResponse**](JumpcloudGoogleEmmCreateEnrollmentTokenResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **enterprises_create_enterprise**
> JumpcloudGoogleEmmEnterprise enterprises_create_enterprise(body)

Create a Google Enterprise

Creates a Google EMM enterprise.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'signupUrlName': 'string', 'enrollmentToken': 'string' }' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateEnterpriseRequest.new # JumpcloudGoogleEmmCreateEnterpriseRequest | 


begin
  #Create a Google Enterprise
  result = api_instance.enterprises_create_enterprise(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_create_enterprise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**JumpcloudGoogleEmmCreateEnterpriseRequest**](JumpcloudGoogleEmmCreateEnterpriseRequest.md)|  | 

### Return type

[**JumpcloudGoogleEmmEnterprise**](JumpcloudGoogleEmmEnterprise.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **enterprises_delete_enterprise**
> Object enterprises_delete_enterprise(enterprise_id)

Delete a Google Enterprise

Removes a Google EMM enterprise.   Warning: This is a destructive operation and will remove all data associated with Google EMM enterprise from JumpCloud including devices and applications associated with the given enterprise.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_id = 'B' # String | 


begin
  #Delete a Google Enterprise
  result = api_instance.enterprises_delete_enterprise(enterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_delete_enterprise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enterprise_id** | **String**|  | 

### Return type

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **enterprises_get_connection_status**
> JumpcloudGoogleEmmConnectionStatus enterprises_get_connection_status(enterprise_id)

Test connection with Google

Gives a connection status between JumpCloud and Google.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId}/connection-status \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_id = 'B' # String | 


begin
  #Test connection with Google
  result = api_instance.enterprises_get_connection_status(enterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_get_connection_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enterprise_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmConnectionStatus**](JumpcloudGoogleEmmConnectionStatus.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **enterprises_list_enterprises**
> JumpcloudGoogleEmmListEnterprisesResponse enterprises_list_enterprises(opts)

List Google Enterprises

Lists all Google EMM enterprises. An empty list indicates that the Organization is not configured with a Google EMM enterprise yet.    Note: Currently only one Google Enterprise per Organization is supported.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0' # String | The offset into the records to return.
}

begin
  #List Google Enterprises
  result = api_instance.enterprises_list_enterprises(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_list_enterprises: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **String**| The number of records to return at once. Limited to 100. | [optional] [default to 100]
 **skip** | **String**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**JumpcloudGoogleEmmListEnterprisesResponse**](JumpcloudGoogleEmmListEnterprisesResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **enterprises_patch_enterprise**
> JumpcloudGoogleEmmEnterprise enterprises_patch_enterprise(bodyenterprise_id)

Update a Google Enterprise

Updates a Google EMM enterprise details.  #### Sample Request ``` curl -X PATCH https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'allowDeviceEnrollment': true, 'deviceGroupId': 'string' }' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::EnterprisesEnterpriseIdBody.new # EnterprisesEnterpriseIdBody | 
enterprise_id = 'B' # String | 


begin
  #Update a Google Enterprise
  result = api_instance.enterprises_patch_enterprise(bodyenterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_patch_enterprise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**EnterprisesEnterpriseIdBody**](EnterprisesEnterpriseIdBody.md)|  | 
 **enterprise_id** | **String**|  | 

### Return type

[**JumpcloudGoogleEmmEnterprise**](JumpcloudGoogleEmmEnterprise.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **signup_urls_create**
> JumpcloudGoogleEmmSignupURL signup_urls_create

Get a Signup URL to enroll Google enterprise

Creates a Google EMM enterprise signup URL.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/signup-urls \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new

begin
  #Get a Signup URL to enroll Google enterprise
  result = api_instance.signup_urls_create
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->signup_urls_create: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JumpcloudGoogleEmmSignupURL**](JumpcloudGoogleEmmSignupURL.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **web_tokens_create_web_token**
> JumpcloudGoogleEmmWebToken web_tokens_create_web_token(body)

Get a web token to render Google Play iFrame

Creates a web token to access an embeddable managed Google Play web UI for a given Google EMM enterprise.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/web-tokens \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```

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

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateWebTokenRequest.new # JumpcloudGoogleEmmCreateWebTokenRequest | 


begin
  #Get a web token to render Google Play iFrame
  result = api_instance.web_tokens_create_web_token(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->web_tokens_create_web_token: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**JumpcloudGoogleEmmCreateWebTokenRequest**](JumpcloudGoogleEmmCreateWebTokenRequest.md)|  | 

### Return type

[**JumpcloudGoogleEmmWebToken**](JumpcloudGoogleEmmWebToken.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



