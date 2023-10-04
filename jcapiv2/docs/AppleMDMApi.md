# JCAPIv2::AppleMDMApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applemdms_csrget**](AppleMDMApi.md#applemdms_csrget) | **GET** /applemdms/{apple_mdm_id}/csr | Get Apple MDM CSR Plist
[**applemdms_delete**](AppleMDMApi.md#applemdms_delete) | **DELETE** /applemdms/{id} | Delete an Apple MDM
[**applemdms_deletedevice**](AppleMDMApi.md#applemdms_deletedevice) | **DELETE** /applemdms/{apple_mdm_id}/devices/{device_id} | Remove an Apple MDM Device&#x27;s Enrollment
[**applemdms_depkeyget**](AppleMDMApi.md#applemdms_depkeyget) | **GET** /applemdms/{apple_mdm_id}/depkey | Get Apple MDM DEP Public Key
[**applemdms_devices_clear_activation_lock**](AppleMDMApi.md#applemdms_devices_clear_activation_lock) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock | Clears the Activation Lock for a Device
[**applemdms_devices_os_update_status**](AppleMDMApi.md#applemdms_devices_os_update_status) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/osUpdateStatus | Request the status of an OS update for a device
[**applemdms_devices_refresh_activation_lock_information**](AppleMDMApi.md#applemdms_devices_refresh_activation_lock_information) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation | Refresh activation lock information for a device
[**applemdms_devices_schedule_os_update**](AppleMDMApi.md#applemdms_devices_schedule_os_update) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/scheduleOSUpdate | Schedule an OS update for a device
[**applemdms_deviceserase**](AppleMDMApi.md#applemdms_deviceserase) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/erase | Erase Device
[**applemdms_deviceslist**](AppleMDMApi.md#applemdms_deviceslist) | **GET** /applemdms/{apple_mdm_id}/devices | List AppleMDM Devices
[**applemdms_deviceslock**](AppleMDMApi.md#applemdms_deviceslock) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/lock | Lock Device
[**applemdms_devicesrestart**](AppleMDMApi.md#applemdms_devicesrestart) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/restart | Restart Device
[**applemdms_devicesshutdown**](AppleMDMApi.md#applemdms_devicesshutdown) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/shutdown | Shut Down Device
[**applemdms_enrollmentprofilesget**](AppleMDMApi.md#applemdms_enrollmentprofilesget) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles/{id} | Get an Apple MDM Enrollment Profile
[**applemdms_enrollmentprofileslist**](AppleMDMApi.md#applemdms_enrollmentprofileslist) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles | List Apple MDM Enrollment Profiles
[**applemdms_getdevice**](AppleMDMApi.md#applemdms_getdevice) | **GET** /applemdms/{apple_mdm_id}/devices/{device_id} | Details of an AppleMDM Device
[**applemdms_list**](AppleMDMApi.md#applemdms_list) | **GET** /applemdms | List Apple MDMs
[**applemdms_put**](AppleMDMApi.md#applemdms_put) | **PUT** /applemdms/{id} | Update an Apple MDM
[**applemdms_refreshdepdevices**](AppleMDMApi.md#applemdms_refreshdepdevices) | **POST** /applemdms/{apple_mdm_id}/refreshdepdevices | Refresh DEP Devices

# **applemdms_csrget**
> AppleMdmSignedCsrPlist applemdms_csrget(apple_mdm_id, opts)

Get Apple MDM CSR Plist

Retrieves an Apple MDM signed CSR Plist for an organization.  The user must supply the returned plist to Apple for signing, and then provide the certificate provided by Apple back into the PUT API.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/csr \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Apple MDM CSR Plist
  result = api_instance.applemdms_csrget(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_csrget: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMdmSignedCsrPlist**](AppleMdmSignedCsrPlist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream



# **applemdms_delete**
> AppleMDM applemdms_delete(id, opts)

Delete an Apple MDM

Removes an Apple MDM configuration.  Warning: This is a destructive operation and will remove your Apple Push Certificates.  We will no longer be able to manage your devices and the only recovery option is to re-register all devices into MDM.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete an Apple MDM
  result = api_instance.applemdms_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMDM**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_deletedevice**
> AppleMdmDevice applemdms_deletedevice(apple_mdm_id, device_id, opts)

Remove an Apple MDM Device's Enrollment

Remove a single Apple MDM device from MDM enrollment.  #### Sample Request ```   curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Remove an Apple MDM Device's Enrollment
  result = api_instance.applemdms_deletedevice(apple_mdm_id, device_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deletedevice: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMdmDevice**](AppleMdmDevice.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_depkeyget**
> AppleMdmPublicKeyCert applemdms_depkeyget(apple_mdm_id, opts)

Get Apple MDM DEP Public Key

Retrieves an Apple MDM DEP Public Key.  #### Sample Request  ``` curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/depkey \\   -H 'accept: application/x-pem-file' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Apple MDM DEP Public Key
  result = api_instance.applemdms_depkeyget(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_depkeyget: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMdmPublicKeyCert**](AppleMdmPublicKeyCert.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/x-pem-file



# **applemdms_devices_clear_activation_lock**
> applemdms_devices_clear_activation_lock(apple_mdm_id, device_id, opts)

Clears the Activation Lock for a Device

Clears the activation lock on the specified device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Clears the Activation Lock for a Device
  api_instance.applemdms_devices_clear_activation_lock(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_clear_activation_lock: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_devices_os_update_status**
> applemdms_devices_os_update_status(apple_mdm_id, device_id, opts)

Request the status of an OS update for a device

Pass through to request the status of an OS update #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/osUpdateStatus \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Request the status of an OS update for a device
  api_instance.applemdms_devices_os_update_status(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_os_update_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_devices_refresh_activation_lock_information**
> applemdms_devices_refresh_activation_lock_information(apple_mdm_id, device_id, opts)

Refresh activation lock information for a device

Refreshes the activation lock information for a device  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Refresh activation lock information for a device
  api_instance.applemdms_devices_refresh_activation_lock_information(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_refresh_activation_lock_information: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_devices_schedule_os_update**
> applemdms_devices_schedule_os_update(apple_mdm_iddevice_id, opts)

Schedule an OS update for a device

Schedules an OS update for a device  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/scheduleOSUpdate \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"install_action\": \"INSTALL_ASAP\", \"product_key\": \"key\"}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::ScheduleOSUpdate.new # ScheduleOSUpdate | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Schedule an OS update for a device
  api_instance.applemdms_devices_schedule_os_update(apple_mdm_iddevice_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_schedule_os_update: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **body** | [**ScheduleOSUpdate**](ScheduleOSUpdate.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_deviceserase**
> applemdms_deviceserase(apple_mdm_iddevice_id, opts)

Erase Device

Erases a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/erase \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdEraseBody.new # DeviceIdEraseBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Erase Device
  api_instance.applemdms_deviceserase(apple_mdm_iddevice_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceserase: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **body** | [**DeviceIdEraseBody**](DeviceIdEraseBody.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_deviceslist**
> Array&lt;AppleMdmDevice&gt; applemdms_deviceslist(apple_mdm_id, opts)

List AppleMDM Devices

Lists all Apple MDM devices.  The filter and sort queries will allow the following fields: `createdAt` `depRegistered` `enrolled` `id` `osVersion` `serialNumber` `udid`  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_total_count: 56 # Integer | 
}

begin
  #List AppleMDM Devices
  result = api_instance.applemdms_deviceslist(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceslist: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **x_total_count** | **Integer**|  | [optional] 

### Return type

[**Array&lt;AppleMdmDevice&gt;**](AppleMdmDevice.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_deviceslock**
> applemdms_deviceslock(apple_mdm_iddevice_id, opts)

Lock Device

Locks a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/lock \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdLockBody.new # DeviceIdLockBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lock Device
  api_instance.applemdms_deviceslock(apple_mdm_iddevice_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceslock: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **body** | [**DeviceIdLockBody**](DeviceIdLockBody.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_devicesrestart**
> applemdms_devicesrestart(apple_mdm_iddevice_id, opts)

Restart Device

Restarts a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/restart \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"kextPaths\": [\"Path1\", \"Path2\"]}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdRestartBody.new # DeviceIdRestartBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Restart Device
  api_instance.applemdms_devicesrestart(apple_mdm_iddevice_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devicesrestart: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **body** | [**DeviceIdRestartBody**](DeviceIdRestartBody.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_devicesshutdown**
> applemdms_devicesshutdown(apple_mdm_id, device_id, opts)

Shut Down Device

Shuts down a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/shutdown \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Shut Down Device
  api_instance.applemdms_devicesshutdown(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devicesshutdown: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_enrollmentprofilesget**
> Mobileconfig applemdms_enrollmentprofilesget(apple_mdm_id, id, opts)

Get an Apple MDM Enrollment Profile

Get an enrollment profile  Currently only requesting the mobileconfig is supported.  #### Sample Request  ``` curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles/{ID} \\   -H 'accept: application/x-apple-aspen-config' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an Apple MDM Enrollment Profile
  result = api_instance.applemdms_enrollmentprofilesget(apple_mdm_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_enrollmentprofilesget: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Mobileconfig**](Mobileconfig.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/x-apple-aspen-config



# **applemdms_enrollmentprofileslist**
> Array&lt;AppleMDM&gt; applemdms_enrollmentprofileslist(apple_mdm_id, opts)

List Apple MDM Enrollment Profiles

Get a list of enrollment profiles for an apple mdm.  Note: currently only one enrollment profile is supported.  #### Sample Request ```  curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Apple MDM Enrollment Profiles
  result = api_instance.applemdms_enrollmentprofileslist(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_enrollmentprofileslist: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;AppleMDM&gt;**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_getdevice**
> AppleMdmDevice applemdms_getdevice(apple_mdm_id, device_id, opts)

Details of an AppleMDM Device

Gets a single Apple MDM device.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Details of an AppleMDM Device
  result = api_instance.applemdms_getdevice(apple_mdm_id, device_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_getdevice: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **device_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMdmDevice**](AppleMdmDevice.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_list**
> Array&lt;AppleMDM&gt; applemdms_list(opts)

List Apple MDMs

Get a list of all Apple MDM configurations.  An empty topic indicates that a signed certificate from Apple has not been provided to the PUT endpoint yet.  Note: currently only one MDM configuration per organization is supported.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/applemdms \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 1, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List Apple MDMs
  result = api_instance.applemdms_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 
 **limit** | **Integer**|  | [optional] [default to 1]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 

### Return type

[**Array&lt;AppleMDM&gt;**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **applemdms_put**
> AppleMDM applemdms_put(id, opts)

Update an Apple MDM

Updates an Apple MDM configuration.  This endpoint is used to supply JumpCloud with a signed certificate from Apple in order to finalize the setup and allow JumpCloud to manage your devices.  It may also be used to update the DEP Settings.  #### Sample Request ```   curl -X PUT https://console.jumpcloud.com/api/v2/applemdms/{ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"MDM name\",     \"appleSignedCert\": \"{CERTIFICATE}\",     \"encryptedDepServerToken\": \"{SERVER_TOKEN}\",     \"dep\": {       \"welcomeScreen\": {         \"title\": \"Welcome\",         \"paragraph\": \"In just a few steps, you will be working securely from your Mac.\",         \"button\": \"continue\",       },     },   }' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AppleMdmPatch.new # AppleMdmPatch | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update an Apple MDM
  result = api_instance.applemdms_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **body** | [**AppleMdmPatch**](AppleMdmPatch.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**AppleMDM**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_refreshdepdevices**
> applemdms_refreshdepdevices(apple_mdm_id, opts)

Refresh DEP Devices

Refreshes the list of devices that a JumpCloud admin has added to their virtual MDM in Apple Business Manager - ABM so that they can be DEP enrolled with JumpCloud.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/refreshdepdevices \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Refresh DEP Devices
  api_instance.applemdms_refreshdepdevices(apple_mdm_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_refreshdepdevices: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



