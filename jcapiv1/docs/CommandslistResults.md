# JCAPIv1::CommandslistResults

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_id** | **String** | The ID of the command. | [optional] 
**command** | **String** | The Command to execute. | [optional] 
**command_type** | **String** | The Command OS. | [optional] 
**launch_type** | **String** | How the Command is executed. | [optional] 
**listens_to** | **String** |  | [optional] 
**name** | **String** | The name of the Command. | [optional] 
**organization** | **String** | The ID of the Organization. | [optional] 
**schedule** | **String** | A crontab that consists of: [ (seconds) (minutes) (hours) (days of month) (months) (weekdays) ] or [ immediate ]. If you send this as an empty string, it will run immediately. | [optional] 
**schedule_repeat_type** | **String** | When the command will repeat. | [optional] 
**trigger** | **String** | Trigger to execute command. | [optional] 


