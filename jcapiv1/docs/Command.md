# JCAPIv1::Command

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**command** | **String** | The command to execute on the server. | 
**command_runners** | **Array&lt;String&gt;** | An array of IDs of the Command Runner Users that can execute this command. | [optional] 
**command_type** | **String** | The Command OS | [default to &#x27;linux&#x27;]
**files** | **Array&lt;String&gt;** | An array of file IDs to include with the command. | [optional] 
**launch_type** | **String** | How the command will execute. | [optional] 
**listens_to** | **String** |  | [optional] 
**name** | **String** |  | 
**organization** | **String** | The ID of the organization. | [optional] 
**schedule** | **String** | A crontab that consists of: [ (seconds) (minutes) (hours) (days of month) (months) (weekdays) ] or [ immediate ]. If you send this as an empty string, it will run immediately.  | [optional] 
**schedule_repeat_type** | **String** | When the command will repeat. | [optional] 
**schedule_year** | **Integer** | The year that a scheduled command will launch in. | [optional] 
**shell** | **String** | The shell used to run the command. | [optional] 
**sudo** | **BOOLEAN** |  | [optional] 
**systems** | **Array&lt;String&gt;** | Not used. Use /api/v2/commands/{id}/associations to bind commands to systems. | [optional] 
**template** | **String** | The template this command was created from | [optional] 
**time_to_live_seconds** | **Integer** | Time in seconds a command can wait in the queue to be run before timing out | [optional] 
**timeout** | **String** | The time in seconds to allow the command to run for. | [optional] 
**trigger** | **String** | The name of the command trigger. | [optional] 
**user** | **String** | The ID of the system user to run the command as. This field is required when creating a command with a commandType of \&quot;mac\&quot; or \&quot;linux\&quot;. | [optional] 

