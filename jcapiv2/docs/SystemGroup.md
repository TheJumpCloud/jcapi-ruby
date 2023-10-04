# JCAPIv2::SystemGroup

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**attributes** | [**GraphAttributes**](GraphAttributes.md) |  | [optional] 
**description** | **String** | Description of a System Group | [optional] 
**email** | **String** | E-mail address associated with a System Group | [optional] 
**id** | **String** | ObjectId uniquely identifying a System Group. | [optional] 
**member_query** | [**FilterQuery**](FilterQuery.md) |  | [optional] 
**member_query_exemptions** | [**Array&lt;GraphObject&gt;**](GraphObject.md) | Array of GraphObjects exempted from the query | [optional] 
**member_suggestions_notify** | **BOOLEAN** | True if notification emails are to be sent for membership suggestions. | [optional] 
**membership_method** | [**GroupMembershipMethodType**](GroupMembershipMethodType.md) |  | [optional] 
**name** | **String** | Display name of a System Group. | [optional] 
**type** | **String** | The type of the group; always &#x27;system&#x27; for a System Group. | [optional] 

