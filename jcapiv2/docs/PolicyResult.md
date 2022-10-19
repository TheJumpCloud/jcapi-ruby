# JCAPIv2::PolicyResult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**detail** | **String** | Details pertaining to the policy result. | [optional] 
**ended_at** | **DateTime** | The end of the policy application. | [optional] 
**exit_status** | **Integer** | The 32-bit unsigned exit status from the applying the policy. | [optional] 
**id** | **String** | ObjectId uniquely identifying a Policy Result. | [optional] 
**policy_id** | **String** | ObjectId uniquely identifying the parent Policy. | [optional] 
**started_at** | **DateTime** | The start of the policy application. | [optional] 
**state** | **String** | Enumeration describing the state of the policy. Success, failed, or pending. | [optional] 
**std_err** | **String** | The STDERR output from applying the policy. | [optional] 
**std_out** | **String** | The STDOUT output from applying the policy. | [optional] 
**success** | **BOOLEAN** | True if the policy was successfully applied; false otherwise. | [optional] 
**system_id** | **String** | ObjectId uniquely identifying the parent System. | [optional] 

