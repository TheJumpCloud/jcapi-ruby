# JCAPIv2::PolicyTemplateWithDetails

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | ObjectId uniquely identifying a Policy Template. | [optional] 
**name** | **String** | The unique name for the Policy Template. | [optional] 
**description** | **String** | The default description for the Policy. | [optional] 
**display_name** | **String** | The default display name for the Policy. | [optional] 
**os_meta_family** | **String** |  | [optional] 
**config_fields** | [**Array&lt;PolicyTemplateConfigField&gt;**](PolicyTemplateConfigField.md) | An unordered list of all the fields that can be configured for this Policy Template. | [optional] 
**activation** | **String** | Requirements before the policy can be activated. | [optional] 
**behavior** | **String** | Specifics about the behavior of the policy. | [optional] 


