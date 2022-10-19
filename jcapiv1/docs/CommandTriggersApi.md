# JCAPIv1::CommandTriggersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**command_trigger_webhook_post**](CommandTriggersApi.md#command_trigger_webhook_post) | **POST** /command/trigger/{triggername} | Launch a command via a Trigger

# **command_trigger_webhook_post**
> Triggerreturn command_trigger_webhook_post(triggername, opts)

Launch a command via a Trigger

This endpoint allows you to launch a command based on a defined trigger.  #### Sample Requests  **Launch a Command via a Trigger**  ``` curl --silent \\      -X 'POST' \\      -H \"x-api-key: {API_KEY}\" \\      \"https://console.jumpcloud.com/api/command/trigger/{TriggerName}\" ``` **Launch a Command via a Trigger passing a JSON object to the command** ``` curl --silent \\      -X 'POST' \\      -H \"x-api-key: {API_KEY}\" \\      -H 'Accept: application/json' \\      -H 'Content-Type: application/json' \\      -d '{ \"srcip\":\"192.168.2.32\", \"attack\":\"Cross Site Scripting Attempt\" }' \\      \"https://console.jumpcloud.com/api/command/trigger/{TriggerName}\" ```

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
triggername = 'triggername_example' # String | 
opts = { 
  body: nil # Object | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Launch a command via a Trigger
  result = api_instance.command_trigger_webhook_post(triggername, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandTriggersApi->command_trigger_webhook_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **triggername** | **String**|  | 
 **body** | [**Object**](Object.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 

### Return type

[**Triggerreturn**](Triggerreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



