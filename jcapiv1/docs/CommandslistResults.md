# JCAPIv1::CommandslistResults

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** | The name of the Command. | [optional] 
**command** | **String** | The Command to execute. | [optional] 
**command_type** | **String** | The Command OS. | [optional] 
**launch_type** | **String** | How the Command is executed. | [optional] 
**listens_to** | **String** |  | [optional] 
**schedule** | **String** | A crontab that consists of: [ (seconds) (minutes) (hours) (days of month) (months) (weekdays) ] or [ immediate ]. If you send this as an empty string, it will run immediately.  | [optional] 
**trigger** | **String** | trigger to execute command. | [optional] 
**schedule_repeat_type** | **String** | When the command will repeat. | [optional] 
**organization** | **String** | The ID of the Organization. | [optional] 
**_id** | **String** | The ID of the command. | [optional] 


