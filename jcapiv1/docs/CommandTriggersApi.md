# JCAPIv1::CommandTriggersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**command_trigger_webhook_post**](CommandTriggersApi.md#command_trigger_webhook_post) | **POST** /command/trigger/{triggername} | Run a Command assigned to a webhook


# **command_trigger_webhook_post**
> command_trigger_webhook_post(triggername, content_type, accept)

Run a Command assigned to a webhook

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

api_instance = JCAPIv1::CommandTriggersApi.new

triggername = "triggername_example" # String | 

content_type = "application/json" # String | 

accept = "application/json" # String | 


begin
  #Run a Command assigned to a webhook
  api_instance.command_trigger_webhook_post(triggername, content_type, accept)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandTriggersApi->command_trigger_webhook_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **triggername** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



