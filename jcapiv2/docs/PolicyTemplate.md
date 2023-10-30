# JCAPIv2::PolicyTemplate

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**activation** | **String** | Requirements before the policy can be activated. | [optional] 
**alert** | **String** | Text to describe any risk associated with this policy. | [optional] 
**behavior** | **String** | Specifics about the behavior of the policy. | [optional] 
**delivery_types** | **Array&lt;String&gt;** | The supported delivery mechanisms for this policy template. | [optional] 
**description** | **String** | The default description for the Policy. | [optional] 
**display_name** | **String** | The default display name for the Policy. | [optional] 
**id** | **String** | ObjectId uniquely identifying a Policy Template. | [optional] 
**name** | **String** | The unique name for the Policy Template. | [optional] 
**os_meta_family** | **String** |  | [optional] 
**os_restrictions** | [**Array&lt;OSRestriction&gt;**](OSRestriction.md) |  | [optional] 
**reference** | **String** | URL to visit for further information. | [optional] 
**state** | **String** | String describing the release status of the policy template. | [optional] [default to &#x27;&#x27;]

