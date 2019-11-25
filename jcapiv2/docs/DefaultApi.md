# JCAPIv2::DefaultApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**jc_enrollment_profiles_delete**](DefaultApi.md#jc_enrollment_profiles_delete) | **DELETE** /enrollmentprofiles/{enrollment_profile_id} | Delete Enrollment Profile
[**jc_enrollment_profiles_get**](DefaultApi.md#jc_enrollment_profiles_get) | **GET** /enrollmentprofiles/{enrollment_profile_id} | Get Enrollment Profile
[**jc_enrollment_profiles_list**](DefaultApi.md#jc_enrollment_profiles_list) | **GET** /enrollmentprofiles | List Enrollment Profiles
[**jc_enrollment_profiles_post**](DefaultApi.md#jc_enrollment_profiles_post) | **POST** /enrollmentprofiles | Create new Enrollment Profile
[**jc_enrollment_profiles_put**](DefaultApi.md#jc_enrollment_profiles_put) | **PUT** /enrollmentprofiles/{enrollment_profile_id} | Update Enrollment Profile


# **jc_enrollment_profiles_delete**
> JcEnrollmentProfile jc_enrollment_profiles_delete(enrollment_profile_id)

Delete Enrollment Profile

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

api_instance = JCAPIv2::DefaultApi.new

enrollment_profile_id = "enrollment_profile_id_example" # String | 


begin
  #Delete Enrollment Profile
  result = api_instance.jc_enrollment_profiles_delete(enrollment_profile_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DefaultApi->jc_enrollment_profiles_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enrollment_profile_id** | **String**|  | 

### Return type

[**JcEnrollmentProfile**](JcEnrollmentProfile.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jc_enrollment_profiles_get**
> jc_enrollment_profiles_get(enrollment_profile_id, opts)

Get Enrollment Profile

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

api_instance = JCAPIv2::DefaultApi.new

enrollment_profile_id = "enrollment_profile_id_example" # String | 

opts = { 
  body: JCAPIv2::JcEnrollmentProfile.new # JcEnrollmentProfile | 
}

begin
  #Get Enrollment Profile
  api_instance.jc_enrollment_profiles_get(enrollment_profile_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DefaultApi->jc_enrollment_profiles_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enrollment_profile_id** | **String**|  | 
 **body** | [**JcEnrollmentProfile**](JcEnrollmentProfile.md)|  | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jc_enrollment_profiles_list**
> Array&lt;JcEnrollmentProfile&gt; jc_enrollment_profiles_list(opts)

List Enrollment Profiles

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

api_instance = JCAPIv2::DefaultApi.new

opts = { 
  limit: 10, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
}

begin
  #List Enrollment Profiles
  result = api_instance.jc_enrollment_profiles_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DefaultApi->jc_enrollment_profiles_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Integer**|  | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Array&lt;JcEnrollmentProfile&gt;**](JcEnrollmentProfile.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jc_enrollment_profiles_post**
> JcEnrollmentProfile jc_enrollment_profiles_post(opts)

Create new Enrollment Profile

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

api_instance = JCAPIv2::DefaultApi.new

opts = { 
  body: JCAPIv2::Body1.new # Body1 | 
}

begin
  #Create new Enrollment Profile
  result = api_instance.jc_enrollment_profiles_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DefaultApi->jc_enrollment_profiles_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Body1**](Body1.md)|  | [optional] 

### Return type

[**JcEnrollmentProfile**](JcEnrollmentProfile.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **jc_enrollment_profiles_put**
> JcEnrollmentProfile jc_enrollment_profiles_put(enrollment_profile_id, opts)

Update Enrollment Profile

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

api_instance = JCAPIv2::DefaultApi.new

enrollment_profile_id = "enrollment_profile_id_example" # String | 

opts = { 
  body: JCAPIv2::Body2.new # Body2 | 
}

begin
  #Update Enrollment Profile
  result = api_instance.jc_enrollment_profiles_put(enrollment_profile_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DefaultApi->jc_enrollment_profiles_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enrollment_profile_id** | **String**|  | 
 **body** | [**Body2**](Body2.md)|  | [optional] 

### Return type

[**JcEnrollmentProfile**](JcEnrollmentProfile.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



