# JCAPIv2::BulkScheduledStatechangeCreate

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**activation_email_override** | **String** | Send the activation or welcome email to the specified email address upon activation. Can only be used with a single user_id and scheduled activation. This field will be ignored if &#x60;send_activation_emails&#x60; is explicitly set to false. | [optional] 
**send_activation_emails** | **BOOLEAN** | Set to true to send activation or welcome email(s) to each user_id upon activation. Set to false to suppress emails. Can only be used with scheduled activation(s). | [optional] 
**start_date** | **DateTime** | Date and time that scheduled action should occur | 
**state** | **String** | The state to move the user(s) to | 
**user_ids** | **Array&lt;String&gt;** | Array of system user ids to schedule for a state change | 

