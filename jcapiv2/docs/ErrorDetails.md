# JCAPIv2::ErrorDetails

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**code** | **Integer** | HTTP status code | [optional] 
**message** | **String** | Error message | [optional] 
**status** | **String** | HTTP status description | [optional] 
**details** | **Array&lt;Hash&gt;** | Describes a list of objects with more detailed information of the given error. Each detail schema is according to one of the messages defined in Google&#x27;s API: https://github.com/googleapis/googleapis/blob/master/google/rpc/error_details.proto | [optional] 

