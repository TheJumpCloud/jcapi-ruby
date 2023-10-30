# JCAPIv2::UserGroupPut

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**attributes** | [**GroupAttributesUserGroup**](GroupAttributesUserGroup.md) |  | [optional] 
**description** | **String** | Description of a User Group | [optional] 
**email** | **String** | Email address of a User Group | [optional] 
**member_query** | [**FilterQuery**](FilterQuery.md) |  | [optional] 
**member_query_exemptions** | [**Array&lt;GraphObject&gt;**](GraphObject.md) | Array of GraphObjects exempted from the query | [optional] 
**member_suggestions_notify** | **BOOLEAN** | True if notification emails are to be sent for membership suggestions. | [optional] 
**membership_automated** | **BOOLEAN** | True if membership of this group is automatically updated based on the Member Query and Member Query Exemptions, if configured | [optional] 
**name** | **String** | Display name of a User Group. | 

