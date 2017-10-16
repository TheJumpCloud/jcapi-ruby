# JCAPIv1::Command

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | [optional] 
**command** | **String** | The command to execute on the server. | 
**user** | **String** | The ID of the JC managed user to run the command as. | 
**systems** | **Array&lt;String&gt;** | An array of system IDs to run the command on. | [optional] 
**schedule** | **String** | A crontab that consists of: [ (seconds) (minutes) (hours) (days of month) (months) (weekdays) ] or [ immediate ]. If you send this as an empty string, it will run immediately.  | [optional] 
**files** | **Array&lt;String&gt;** | An array of file IDs to include with the command. | [optional] 
**tags** | **Array&lt;String&gt;** | An array of tag IDs to run the command on. | [optional] 
**timeout** | **String** | The time in seconds to allow the command to run for. | [optional] 


