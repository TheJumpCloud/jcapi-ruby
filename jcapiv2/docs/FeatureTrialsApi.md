# JCAPIv2::FeatureTrialsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**feature_trials_get_feature_trials**](FeatureTrialsApi.md#feature_trials_get_feature_trials) | **GET** /featureTrials/{feature_code} | Check current feature trial usage for a specific feature

# **feature_trials_get_feature_trials**
> FeatureTrialData feature_trials_get_feature_trials(feature_code)

Check current feature trial usage for a specific feature

This endpoint get's the current state of a feature trial for an org.  #### Sample Request  ```   curl -X GET \\   https://console.jumpcloud.local/api/v2/featureTrials/zeroTrust \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv2::FeatureTrialsApi.new
feature_code = 'feature_code_example' # String | 


begin
  #Check current feature trial usage for a specific feature
  result = api_instance.feature_trials_get_feature_trials(feature_code)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling FeatureTrialsApi->feature_trials_get_feature_trials: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **feature_code** | **String**|  | 

### Return type

[**FeatureTrialData**](FeatureTrialData.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



