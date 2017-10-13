# SwaggerClient::PolicyResult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**policy_id** | **String** | ObjectId uniquely identifying the parent Policy. | [optional] 
**system_id** | **String** | ObjectId uniquely identifying the parent System. | [optional] 
**id** | **String** | ObjectId uniquely identifying a Policy Result. | [optional] 
**started_at** | **DateTime** | The start of the policy application. | [optional] 
**ended_at** | **DateTime** | The end of the policy application. | [optional] 
**success** | **BOOLEAN** | True if the policy was successfully applied; false otherwise. | [optional] 
**exit_status** | **Integer** | The 32-bit unsigned exit status from the applying the policy. | [optional] 
**std_err** | **String** | The STDERR output from applying the policy. | [optional] 
**std_out** | **String** | The STDOUT output from applying the policy. | [optional] 


