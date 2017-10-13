# SwaggerClient::Commandresult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**command** | **String** | The command that was executed on the system. | [optional] 
**name** | **String** | The name of the command. | [optional] 
**system** | **String** | The id of the system the command was executed on. | [optional] 
**organization** | **String** | The id of the organization. | [optional] 
**workflow_id** | **String** |  | [optional] 
**workflow_instance_id** | **String** |  | [optional] 
**user** | **String** | The user the command ran as. | [optional] 
**sudo** | **BOOLEAN** | If the user had sudo rights | [optional] 
**files** | **Array&lt;String&gt;** | An array of file ids that were included in the command | [optional] 
**request_time** | **Integer** | The time that the command was sent. | [optional] 
**response_time** | **Integer** | The time that the command was completed. | [optional] 
**response** | [**CommandresultResponse**](CommandresultResponse.md) |  | [optional] 
**_id** | **String** |  | [optional] 


