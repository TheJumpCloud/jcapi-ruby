# JCAPIv2::PasswordManagerApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**device_service_get_device**](PasswordManagerApi.md#device_service_get_device) | **GET** /passwordmanager/devices/{UUID} | 
[**device_service_list_devices**](PasswordManagerApi.md#device_service_list_devices) | **GET** /passwordmanager/devices | 

# **device_service_get_device**
> DevicePackageV1Device device_service_get_device(uuid)



Get Device

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

api_instance = JCAPIv2::PasswordManagerApi.new
uuid = 'uuid_example' # String | 


begin
  result = api_instance.device_service_get_device(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PasswordManagerApi->device_service_get_device: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **String**|  | 

### Return type

[**DevicePackageV1Device**](DevicePackageV1Device.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **device_service_list_devices**
> DevicePackageV1ListDevicesResponse device_service_list_devices(opts)



List Devices

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

api_instance = JCAPIv2::PasswordManagerApi.new
opts = { 
  limit: 56, # Integer | 
  skip: 56, # Integer | 
  sort: 'sort_example', # String | 
  fields: ['fields_example'], # Array<String> | 
  filter: ['filter_example'] # Array<String> | 
}

begin
  result = api_instance.device_service_list_devices(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PasswordManagerApi->device_service_list_devices: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] 
 **skip** | **Integer**|  | [optional] 
 **sort** | **String**|  | [optional] 
 **fields** | [**Array&lt;String&gt;**](String.md)|  | [optional] 
 **filter** | [**Array&lt;String&gt;**](String.md)|  | [optional] 

### Return type

[**DevicePackageV1ListDevicesResponse**](DevicePackageV1ListDevicesResponse.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



