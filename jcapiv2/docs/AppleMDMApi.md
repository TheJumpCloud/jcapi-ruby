# JCAPIv2::AppleMDMApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applemdms_delete**](AppleMDMApi.md#applemdms_delete) | **DELETE** /applemdms/{apple_mdm_id} | Delete an Apple MDM
[**applemdms_list**](AppleMDMApi.md#applemdms_list) | **GET** /applemdms | List Apple MDMs
[**applemdms_post**](AppleMDMApi.md#applemdms_post) | **POST** /applemdms | Create Apple MDM
[**applemdms_put**](AppleMDMApi.md#applemdms_put) | **PUT** /applemdms/{apple_mdm_id} | Update an Apple MDM
[**enrollmentprofiles_get**](AppleMDMApi.md#enrollmentprofiles_get) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles/{enrollment_profile_id} | Get an Apple MDM Enrollment Profile
[**enrollmentprofiles_list**](AppleMDMApi.md#enrollmentprofiles_list) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles | List Apple MDM Enrollment Profiles


# **applemdms_delete**
> AppleMDM applemdms_delete(apple_mdm_id, content_type, accept, opts)

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

apple_mdm_id = "apple_mdm_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Delete an Apple MDM
  result = api_instance.applemdms_delete(apple_mdm_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**AppleMDM**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_list**
> Array&lt;AppleMDM&gt; applemdms_list(content_type, accept, opts)

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

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #List Apple MDMs
  result = api_instance.applemdms_list(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;AppleMDM&gt;**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_post**
> InlineResponse201 applemdms_post(content_type, accept, opts)

Create Apple MDM

Creates an Apple MDM Enrollment for an organization. Only one enrollment per organization will be allowed.  Note that this is the first step in completly setting up an MDM Enrollment.  The user must supply the returned plist to Apple for signing, and then provide the certificate provided by Apple back into the PUT API.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/organizations/{Organization_ID}/mdm \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```

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

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::Body.new, # Body | 
  x_org_id: "" # String | 
}

begin
  #Create Apple MDM
  result = api_instance.applemdms_post(content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Body**](Body.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**InlineResponse201**](InlineResponse201.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **applemdms_put**
> AppleMDM applemdms_put(apple_mdm_id, content_type, accept, opts)

Update an Apple MDM

Updates an Apple MDM configuration.  This endpoint is used to supply JumpCloud with a signed certificate from Apple in order to finalize the setup and allow JumpCloud to manage your devices.  #### Sample Request ```   curl -X PUT https://console.jumpcloud.com/api/v2/applemdms/{ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"MDM name\",     \"appleSignedCert\": \"{CERTIFICATE}\"   }' ```

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

apple_mdm_id = "apple_mdm_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  body: JCAPIv2::AppleMdmPatchInput.new, # AppleMdmPatchInput | 
  x_org_id: "" # String | 
}

begin
  #Update an Apple MDM
  result = api_instance.applemdms_put(apple_mdm_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**AppleMdmPatchInput**](AppleMdmPatchInput.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**AppleMDM**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **enrollmentprofiles_get**
> Mobileconfig enrollmentprofiles_get(apple_mdm_id, enrollment_profile_id, content_type, accept, opts)

Get an Apple MDM Enrollment Profile

Get an enrollment profile  Currently only requesting the mobileconfig is supported.  #### Sample Request  ``` curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles/{ENROLLMENT_PROFILE_ID} \\   -H 'accept: application/x-apple-aspen-config' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

apple_mdm_id = "apple_mdm_id_example" # String | 

enrollment_profile_id = "enrollment_profile_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #Get an Apple MDM Enrollment Profile
  result = api_instance.enrollmentprofiles_get(apple_mdm_id, enrollment_profile_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->enrollmentprofiles_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **enrollment_profile_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Mobileconfig**](Mobileconfig.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/x-apple-aspen-config



# **enrollmentprofiles_list**
> Array&lt;AppleMDM&gt; enrollmentprofiles_list(apple_mdm_id, content_type, accept, opts)

List Apple MDM Enrollment Profiles

Get a list of enrollment profiles for an apple mdm.  Note: currently only one enrollment profile is supported.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

apple_mdm_id = "apple_mdm_id_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 

opts = { 
  x_org_id: "" # String | 
}

begin
  #List Apple MDM Enrollment Profiles
  result = api_instance.enrollmentprofiles_list(apple_mdm_id, content_type, accept, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->enrollmentprofiles_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apple_mdm_id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Array&lt;AppleMDM&gt;**](AppleMDM.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



