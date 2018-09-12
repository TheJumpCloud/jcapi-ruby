# JCAPIv1::Systemuserput

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**email** | **String** |  | 
**username** | **String** |  | 
**allow_public_key** | **BOOLEAN** |  | [optional] 
**public_key** | **String** |  | [optional] 
**ssh_keys** | [**Array&lt;Sshkeypost&gt;**](Sshkeypost.md) |  | [optional] 
**sudo** | **BOOLEAN** |  | [optional] 
**enable_managed_uid** | **BOOLEAN** |  | [optional] 
**unix_uid** | **Integer** |  | [optional] 
**unix_guid** | **Integer** |  | [optional] 
**tags** | **Array&lt;String&gt;** |  | [optional] 
**account_locked** | **BOOLEAN** |  | [optional] 
**externally_managed** | **BOOLEAN** |  | [optional] 
**external_dn** | **String** |  | [optional] 
**external_source_type** | **String** |  | [optional] 
**firstname** | **String** |  | [optional] 
**lastname** | **String** |  | [optional] 
**ldap_binding_user** | **BOOLEAN** |  | [optional] 
**enable_user_portal_multifactor** | **BOOLEAN** |  | [optional] 
**attributes** | **Array&lt;Object&gt;** |  | [optional] 
**samba_service_user** | **BOOLEAN** |  | [optional] 
**addresses** | [**Array&lt;SystemuserputpostAddresses&gt;**](SystemuserputpostAddresses.md) | type, poBox, extendedAddress, streetAddress, locality, region, postalCode, country | [optional] 
**job_title** | **String** |  | [optional] 
**department** | **String** |  | [optional] 
**phone_numbers** | [**Array&lt;SystemuserputpostPhoneNumbers&gt;**](SystemuserputpostPhoneNumbers.md) |  | [optional] 
**relationships** | **Array&lt;Object&gt;** |  | [optional] 
**password** | **String** |  | [optional] 
**password_never_expires** | **BOOLEAN** |  | [optional] 
**middlename** | **String** |  | [optional] 
**displayname** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**location** | **String** |  | [optional] 
**cost_center** | **String** |  | [optional] 
**employee_type** | **String** |  | [optional] 
**company** | **String** |  | [optional] 
**employee_identifier** | **String** | Must be unique per user.  | [optional] 


