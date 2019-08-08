# JCAPIv2::SystemInsightsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**systeminsights_list_apps**](SystemInsightsApi.md#systeminsights_list_apps) | **GET** /systeminsights/apps | List System Insights Apps
[**systeminsights_list_apps_0**](SystemInsightsApi.md#systeminsights_list_apps_0) | **GET** /systeminsights/{jc_system_id}/apps | List System Insights System Apps
[**systeminsights_list_browser_plugins**](SystemInsightsApi.md#systeminsights_list_browser_plugins) | **GET** /systeminsights/{jc_system_id}/browser_plugins | List System Insights System Browser Plugins
[**systeminsights_list_browser_plugins_0**](SystemInsightsApi.md#systeminsights_list_browser_plugins_0) | **GET** /systeminsights/browser_plugins | List System Insights Browser Plugins
[**systeminsights_list_chrome_extensions**](SystemInsightsApi.md#systeminsights_list_chrome_extensions) | **GET** /systeminsights/{jc_system_id}/chrome_extensions | List System Insights System Chrome Extensions
[**systeminsights_list_chrome_extensions_0**](SystemInsightsApi.md#systeminsights_list_chrome_extensions_0) | **GET** /systeminsights/chrome_extensions | List System Insights Chrome Extensions
[**systeminsights_list_disk_encryption**](SystemInsightsApi.md#systeminsights_list_disk_encryption) | **GET** /systeminsights/disk_encryption | List System Insights Disk Encryption
[**systeminsights_list_disk_encryption_0**](SystemInsightsApi.md#systeminsights_list_disk_encryption_0) | **GET** /systeminsights/{jc_system_id}/disk_encryption | List System Insights System Disk Encryption
[**systeminsights_list_firefox_addons**](SystemInsightsApi.md#systeminsights_list_firefox_addons) | **GET** /systeminsights/firefox_addons | List System Insights Firefox Addons
[**systeminsights_list_firefox_addons_0**](SystemInsightsApi.md#systeminsights_list_firefox_addons_0) | **GET** /systeminsights/{jc_system_id}/firefox_addons | List System Insights System Firefox Addons
[**systeminsights_list_groups**](SystemInsightsApi.md#systeminsights_list_groups) | **GET** /systeminsights/groups | List System Insights Groups
[**systeminsights_list_groups_0**](SystemInsightsApi.md#systeminsights_list_groups_0) | **GET** /systeminsights/{jc_system_id}/groups | List System Insights System Groups
[**systeminsights_list_interface_addresses**](SystemInsightsApi.md#systeminsights_list_interface_addresses) | **GET** /systeminsights/interface_addresses | List System Insights Interface Addresses
[**systeminsights_list_interface_addresses_0**](SystemInsightsApi.md#systeminsights_list_interface_addresses_0) | **GET** /systeminsights/{jc_system_id}/interface_addresses | List System Insights System Interface Addresses
[**systeminsights_list_mounts**](SystemInsightsApi.md#systeminsights_list_mounts) | **GET** /systeminsights/mounts | List System Insights Mounts
[**systeminsights_list_mounts_0**](SystemInsightsApi.md#systeminsights_list_mounts_0) | **GET** /systeminsights/{jc_system_id}/mounts | List System Insights System Mounts
[**systeminsights_list_os_version**](SystemInsightsApi.md#systeminsights_list_os_version) | **GET** /systeminsights/{jc_system_id}/os_version | List System Insights System OS Version
[**systeminsights_list_os_version_0**](SystemInsightsApi.md#systeminsights_list_os_version_0) | **GET** /systeminsights/os_version | List System Insights OS Version
[**systeminsights_list_safari_extensions**](SystemInsightsApi.md#systeminsights_list_safari_extensions) | **GET** /systeminsights/{jc_system_id}/safari_extensions | List System Insights System Safari Extensions
[**systeminsights_list_safari_extensions_0**](SystemInsightsApi.md#systeminsights_list_safari_extensions_0) | **GET** /systeminsights/safari_extensions | List System Insights Safari Extensions
[**systeminsights_list_system_info**](SystemInsightsApi.md#systeminsights_list_system_info) | **GET** /systeminsights/system_info | List System Insights System Info
[**systeminsights_list_system_info_0**](SystemInsightsApi.md#systeminsights_list_system_info_0) | **GET** /systeminsights/{jc_system_id}/system_info | List System Insights System System Info
[**systeminsights_list_users**](SystemInsightsApi.md#systeminsights_list_users) | **GET** /systeminsights/users | List System Insights Users
[**systeminsights_list_users_0**](SystemInsightsApi.md#systeminsights_list_users_0) | **GET** /systeminsights/{jc_system_id}/users | List System Insights System Users


# **systeminsights_list_apps**
> Array&lt;SystemInsightsApps&gt; systeminsights_list_apps(opts)

List System Insights Apps

Valid filter fields are `jc_system_id` and `bundle_name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Apps
  result = api_instance.systeminsights_list_apps(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_apps: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsApps&gt;**](SystemInsightsApps.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_apps_0**
> Array&lt;SystemInsightsApps&gt; systeminsights_list_apps_0(jc_system_id, opts)

List System Insights System Apps

Valid filter fields are `bundle_name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Apps
  result = api_instance.systeminsights_list_apps_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_apps_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsApps&gt;**](SystemInsightsApps.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_browser_plugins**
> Array&lt;SystemInsightsBrowserPlugins&gt; systeminsights_list_browser_plugins(jc_system_id, opts)

List System Insights System Browser Plugins

Valid filter fields are `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Browser Plugins
  result = api_instance.systeminsights_list_browser_plugins(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_browser_plugins: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsBrowserPlugins&gt;**](SystemInsightsBrowserPlugins.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_browser_plugins_0**
> Array&lt;SystemInsightsBrowserPlugins&gt; systeminsights_list_browser_plugins_0(opts)

List System Insights Browser Plugins

Valid filter fields are `jc_system_id` and `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Browser Plugins
  result = api_instance.systeminsights_list_browser_plugins_0(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_browser_plugins_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsBrowserPlugins&gt;**](SystemInsightsBrowserPlugins.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_chrome_extensions**
> Array&lt;SystemInsightsChromeExtensions&gt; systeminsights_list_chrome_extensions(jc_system_id, opts)

List System Insights System Chrome Extensions

Valid filter fields are `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Chrome Extensions
  result = api_instance.systeminsights_list_chrome_extensions(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_chrome_extensions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsChromeExtensions&gt;**](SystemInsightsChromeExtensions.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_chrome_extensions_0**
> Array&lt;SystemInsightsChromeExtensions&gt; systeminsights_list_chrome_extensions_0(opts)

List System Insights Chrome Extensions

Valid filter fields are `jc_system_id` and `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Chrome Extensions
  result = api_instance.systeminsights_list_chrome_extensions_0(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_chrome_extensions_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsChromeExtensions&gt;**](SystemInsightsChromeExtensions.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_disk_encryption**
> Array&lt;SystemInsightsDiskEncryption&gt; systeminsights_list_disk_encryption(opts)

List System Insights Disk Encryption

Valid filter fields are `jc_system_id` and `encryption_status`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Disk Encryption
  result = api_instance.systeminsights_list_disk_encryption(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_disk_encryption: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsDiskEncryption&gt;**](SystemInsightsDiskEncryption.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_disk_encryption_0**
> Array&lt;SystemInsightsDiskEncryption&gt; systeminsights_list_disk_encryption_0(jc_system_id, opts)

List System Insights System Disk Encryption

Valid filter fields are `encryption_status`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Disk Encryption
  result = api_instance.systeminsights_list_disk_encryption_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_disk_encryption_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsDiskEncryption&gt;**](SystemInsightsDiskEncryption.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_firefox_addons**
> Array&lt;SystemInsightsFirefoxAddons&gt; systeminsights_list_firefox_addons(opts)

List System Insights Firefox Addons

Valid filter fields are `jc_system_id` and `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Firefox Addons
  result = api_instance.systeminsights_list_firefox_addons(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_firefox_addons: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsFirefoxAddons&gt;**](SystemInsightsFirefoxAddons.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_firefox_addons_0**
> Array&lt;SystemInsightsFirefoxAddons&gt; systeminsights_list_firefox_addons_0(jc_system_id, opts)

List System Insights System Firefox Addons

Valid filter fields are `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Firefox Addons
  result = api_instance.systeminsights_list_firefox_addons_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_firefox_addons_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsFirefoxAddons&gt;**](SystemInsightsFirefoxAddons.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_groups**
> Array&lt;SystemInsightsGroups&gt; systeminsights_list_groups(opts)

List System Insights Groups

Valid filter fields are `jc_system_id` and `groupname`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Groups
  result = api_instance.systeminsights_list_groups(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_groups: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsGroups&gt;**](SystemInsightsGroups.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_groups_0**
> Array&lt;SystemInsightsGroups&gt; systeminsights_list_groups_0(jc_system_id, opts)

List System Insights System Groups

Valid filter fields are `groupname`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Groups
  result = api_instance.systeminsights_list_groups_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_groups_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsGroups&gt;**](SystemInsightsGroups.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_interface_addresses**
> Array&lt;SystemInsightsInterfaceAddresses&gt; systeminsights_list_interface_addresses(opts)

List System Insights Interface Addresses

Valid filter fields are `jc_system_id` and `address`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Interface Addresses
  result = api_instance.systeminsights_list_interface_addresses(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_interface_addresses: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsInterfaceAddresses&gt;**](SystemInsightsInterfaceAddresses.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_interface_addresses_0**
> Array&lt;SystemInsightsInterfaceAddresses&gt; systeminsights_list_interface_addresses_0(jc_system_id, opts)

List System Insights System Interface Addresses

Valid filter fields are `address`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Interface Addresses
  result = api_instance.systeminsights_list_interface_addresses_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_interface_addresses_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsInterfaceAddresses&gt;**](SystemInsightsInterfaceAddresses.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_mounts**
> Array&lt;SystemInsightsMounts&gt; systeminsights_list_mounts(opts)

List System Insights Mounts

Valid filter fields are `jc_system_id` and `path`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Mounts
  result = api_instance.systeminsights_list_mounts(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_mounts: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsMounts&gt;**](SystemInsightsMounts.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_mounts_0**
> Array&lt;SystemInsightsMounts&gt; systeminsights_list_mounts_0(jc_system_id, opts)

List System Insights System Mounts

Valid filter fields are `path`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Mounts
  result = api_instance.systeminsights_list_mounts_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_mounts_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsMounts&gt;**](SystemInsightsMounts.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_os_version**
> Array&lt;SystemInsightsOsVersion&gt; systeminsights_list_os_version(jc_system_id, opts)

List System Insights System OS Version

Valid filter fields are `version`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System OS Version
  result = api_instance.systeminsights_list_os_version(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_os_version: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsOsVersion&gt;**](SystemInsightsOsVersion.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_os_version_0**
> Array&lt;SystemInsightsOsVersion&gt; systeminsights_list_os_version_0(opts)

List System Insights OS Version

Valid filter fields are `jc_system_id` and `version`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights OS Version
  result = api_instance.systeminsights_list_os_version_0(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_os_version_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsOsVersion&gt;**](SystemInsightsOsVersion.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_safari_extensions**
> Array&lt;SystemInsightsSafariExtensions&gt; systeminsights_list_safari_extensions(jc_system_id, opts)

List System Insights System Safari Extensions

Valid filter fields are `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Safari Extensions
  result = api_instance.systeminsights_list_safari_extensions(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_safari_extensions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsSafariExtensions&gt;**](SystemInsightsSafariExtensions.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_safari_extensions_0**
> Array&lt;SystemInsightsSafariExtensions&gt; systeminsights_list_safari_extensions_0(opts)

List System Insights Safari Extensions

Valid filter fields are `jc_system_id` and `name`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Safari Extensions
  result = api_instance.systeminsights_list_safari_extensions_0(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_safari_extensions_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsSafariExtensions&gt;**](SystemInsightsSafariExtensions.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_system_info**
> Array&lt;SystemInsightsSystemInfo&gt; systeminsights_list_system_info(opts)

List System Insights System Info

Valid filter fields are `jc_system_id` and `cpu_subtype`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Info
  result = api_instance.systeminsights_list_system_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_system_info: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsSystemInfo&gt;**](SystemInsightsSystemInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_system_info_0**
> Array&lt;SystemInsightsSystemInfo&gt; systeminsights_list_system_info_0(jc_system_id, opts)

List System Insights System System Info

Valid filter fields are `cpu_subtype`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System System Info
  result = api_instance.systeminsights_list_system_info_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_system_info_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsSystemInfo&gt;**](SystemInsightsSystemInfo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_users**
> Array&lt;SystemInsightsUsers&gt; systeminsights_list_users(opts)

List System Insights Users

Valid filter fields are `jc_system_id` and `username`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights Users
  result = api_instance.systeminsights_list_users(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_users: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsUsers&gt;**](SystemInsightsUsers.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **systeminsights_list_users_0**
> Array&lt;SystemInsightsUsers&gt; systeminsights_list_users_0(jc_system_id, opts)

List System Insights System Users

Valid filter fields are `username`.

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SystemInsightsApi.new

jc_system_id = "jc_system_id_example" # String | 

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ["filter_example"] # Array<String> | Supported operators are: eq
}

begin
  #List System Insights System Users
  result = api_instance.systeminsights_list_users_0(jc_system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_users_0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jc_system_id** | **String**|  | 
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | [**Array&lt;String&gt;**](String.md)| Supported operators are: eq | [optional] 

### Return type

[**Array&lt;SystemInsightsUsers&gt;**](SystemInsightsUsers.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



