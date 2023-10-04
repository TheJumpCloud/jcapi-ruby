# JCAPIv1::CommandresultslistResults

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_id** | **String** | The ID of the command result. | [optional] 
**command** | **String** | The command that was executed on the system. | [optional] 
**exit_code** | **Integer** | The stderr output from the command that ran. | [optional] 
**name** | **String** | The name of the command. | [optional] 
**request_time** | **DateTime** | The time (UTC) that the command was sent. | [optional] 
**response_time** | **DateTime** | The time (UTC) that the command was completed. | [optional] 
**sudo** | **BOOLEAN** | If the user had sudo rights. | [optional] 
**system** | **String** | The display name of the system the command was executed on. | [optional] 
**system_id** | **String** | The id of the system the command was executed on. | [optional] 
**user** | **String** | The user the command ran as. | [optional] 
**workflow_id** | **String** | The id for the command that ran on the system. | [optional] 

