# JCAPIv2::SubscriptionsApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subscriptions_get**](SubscriptionsApi.md#subscriptions_get) | **GET** /subscriptions | Lists all the Pricing &amp; Packaging Subscriptions

# **subscriptions_get**
> Array&lt;Subscription&gt; subscriptions_get

Lists all the Pricing & Packaging Subscriptions

This endpoint returns all pricing & packaging subscriptions.  ##### Sample Request  ```  curl -X GET  https://console.jumpcloud.com/api/v2/subscriptions \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```

### Example
```ruby
# load the gem
require 'jcapiv2'

api_instance = JCAPIv2::SubscriptionsApi.new

begin
  #Lists all the Pricing & Packaging Subscriptions
  result = api_instance.subscriptions_get
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SubscriptionsApi->subscriptions_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;Subscription&gt;**](Subscription.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



